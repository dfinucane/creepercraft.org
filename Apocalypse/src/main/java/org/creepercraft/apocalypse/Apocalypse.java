package org.creepercraft.apocalypse;

import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.player.PlayerJoinEvent;
import org.bukkit.plugin.java.JavaPlugin;
import org.bukkit.command.*;

public final class Apocalypse extends JavaPlugin implements Listener {
	private final EvilSpawner evilSpawner;

	public Apocalypse() {
		this.evilSpawner = new EvilSpawner(this);
	}

	@Override
	public void onEnable() {
		getLogger().info("The Apocalypse is beginning.  Beware.");
		getServer().getPluginManager().registerEvents(this, this);
		this.evilSpawner.runTaskTimer(this, 100, 10*60*20);
	}

	@Override
	public void onDisable() {
		this.evilSpawner.cancel();
	}

	@Override
	public boolean onCommand(CommandSender sender, Command command, String commandLabel, String[] args) {

		return false;
	}

	@EventHandler
	public void onPlayerJoinEvent(PlayerJoinEvent playerJoinEvent) {
		Player player = playerJoinEvent.getPlayer();
	}
}
