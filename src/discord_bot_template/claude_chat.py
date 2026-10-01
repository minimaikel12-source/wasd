"""Chat with Claude from Discord, like the normal Claude app.

Each Discord channel keeps its own conversation history,
so Claude remembers what was said earlier in that channel.
"""

import os
from collections import defaultdict

import anthropic

CLAUDE_MODEL = os.getenv("CLAUDE_MODEL", "claude-opus-5-5")
# How many past messages (user + assistant) to keep per channel.
CLAUDE_HISTORY_LIMIT = int(os.getenv("CLAUDE_HISTORY_LIMIT", "40"))
DISCORD_MESSAGE_LIMIT = 2000

SYSTEM_PROMPT = (
    "You are Claude, a helpful AI assistant made by Anthropic, chatting with "
    "people in a Discord server. Reply in the same language the user writes in. "
    "Keep answers readable in Discord: use Markdown sparingly and code blocks "
    "for code."
)

# Created lazily so the bot still starts without an API key.
_client: anthropic.AsyncAnthropic | None = None
_histories: dict[int, list[dict]] = defaultdict(list)


def _get_client() -> anthropic.AsyncAnthropic:
    global _client  # noqa: PLW0603
    if _client is None:
        _client = anthropic.AsyncAnthropic()  # reads ANTHROPIC_API_KEY
    return _client


def reset_history(channel_id: int) -> None:
    """Forget the conversation for a channel."""
    _histories.pop(channel_id, None)


async def ask_claude(channel_id: int, author: str, prompt: str) -> str:
    """Send a message in the channel's conversation and return Claude's reply."""
    history = _histories[channel_id]
    history.append({"role": "user", "content": f"{author}: {prompt}"})

    try:
        response = await _get_client().beta.messages.create(
            model=CLAUDE_MODEL,
            max_tokens=16000,
            system=SYSTEM_PROMPT,
            messages=history,
            # If a safety classifier declines, retry on a fallback model automatically.
            betas=["server-side-fallback-2026-07-01"],
            fallbacks="default",
        )
    except anthropic.AuthenticationError:
        history.pop()
        return "⚠️ Invalid or missing `ANTHROPIC_API_KEY`. Check your `.env` file."
    except anthropic.RateLimitError:
        history.pop()
        return "⚠️ Rate limited by the Claude API. Try again in a moment."
    except anthropic.APIStatusError as e:
        history.pop()
        return f"⚠️ Claude API error ({e.status_code}): {e.message}"
    except anthropic.APIConnectionError:
        history.pop()
        return "⚠️ Could not reach the Claude API."

    if response.stop_reason == "refusal":
        history.pop()
        return "🚫 Claude declined to answer that."

    reply = "".join(b.text for b in response.content if b.type == "text").strip()
    # Keep the full content so thinking blocks are passed back unchanged.
    history.append({"role": "assistant", "content": response.content})

    # Trim old turns, always starting the history on a user message.
    while len(history) > CLAUDE_HISTORY_LIMIT:
        del history[:2]

    return reply or "(empty reply)"


def split_message(text: str, limit: int = DISCORD_MESSAGE_LIMIT) -> list[str]:
    """Split a long reply into chunks that fit Discord's message limit."""
    chunks = []
    while len(text) > limit:
        cut = text.rfind("\n", 0, limit)
        if cut <= 0:
            cut = limit
        chunks.append(text[:cut])
        text = text[cut:].lstrip("\n")
    if text:
        chunks.append(text)
    return chunks
