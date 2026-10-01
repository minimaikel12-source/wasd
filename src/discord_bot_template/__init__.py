import os

import discord
from discord.ext import commands
from dotenv import load_dotenv

load_dotenv()

from .claude_chat import ask_claude, reset_history, split_message  # noqa: E402

DISCORD_TOKEN = os.getenv("DISCORD_TOKEN", "")
DISCORD_GUILD = int(os.getenv("DISCORD_GUILD", "0"))

intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="!", intents=intents)


@bot.event
async def on_ready():
    """Let us know we logged in properly."""
    print(f"Logged in as {bot.user} (ID: {bot.user.id})")


@bot.event
async def on_message(message: discord.Message):
    """Reply with Claude whenever the bot is @mentioned."""
    if message.author.bot:
        return
    if bot.user in message.mentions and not message.content.startswith("!"):
        prompt = message.content.replace(f"<@{bot.user.id}>", "").strip()
        if prompt:
            async with message.channel.typing():
                reply = await ask_claude(
                    message.channel.id, message.author.display_name, prompt
                )
            for chunk in split_message(reply):
                await message.reply(chunk)
            return
    await bot.process_commands(message)


@bot.tree.command(
    description="Chat with Claude",
    guild=discord.Object(id=DISCORD_GUILD),
)
async def claude(interaction: discord.Interaction, prompt: str):
    """Ask Claude something (keeps the conversation per channel)."""
    await interaction.response.defer(thinking=True)
    reply = await ask_claude(
        interaction.channel_id, interaction.user.display_name, prompt
    )
    chunks = split_message(f"> {prompt[:200]}\n\n{reply}")
    for chunk in chunks:
        await interaction.followup.send(chunk)


@bot.command(name="claude", description="Chat with Claude")
async def claude_prefix(ctx, *, prompt: str):
    """Ask Claude something with !claude <message>."""
    async with ctx.typing():
        reply = await ask_claude(ctx.channel.id, ctx.author.display_name, prompt)
    for chunk in split_message(reply):
        await ctx.reply(chunk)


@bot.command(name="reset", description="Forget the Claude conversation here")
async def reset(ctx):
    """Clear Claude's memory for this channel."""
    reset_history(ctx.channel.id)
    await ctx.reply("🧹 Conversation with Claude reset.")


@bot.tree.command(
    description="Replies with Hello!",
    guild=discord.Object(id=DISCORD_GUILD),
)
async def hello(interaction: discord.Interaction):
    """Just say hello."""
    print("Responding to /hello")
    await interaction.response.send_message("Hello, how are you?")


@bot.command(
    description="Replies to !whatsup",
    guild=discord.Object(id=DISCORD_GUILD),
)
async def whatsup(ctx):
    """Tell us what's up."""
    print("Responding to !whatsup")
    await ctx.send("Nothing much")


@bot.command(
    description="Sync the bot tree to update Slash command changes to the server",
    guild=discord.Object(id=DISCORD_GUILD),
)
async def sync(ctx):
    """Sync the bot command tree for Slash commands."""
    print("Syncing the command tree...")
    await bot.tree.sync(guild=discord.Object(id=DISCORD_GUILD))
    await ctx.reply("✅ Command tree synced")
    print("Sync Complete!")


def main():
    """Run the bot."""
    bot.run(DISCORD_TOKEN)
    print("Shutting down.")


if __name__ == "__main__":
    main()
