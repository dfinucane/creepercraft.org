package org.creepercraft.plugin;

import org.bukkit.ChatColor;
import org.bukkit.entity.Player;
import org.bukkit.event.EventHandler;
import org.bukkit.event.Listener;
import org.bukkit.event.player.PlayerJoinEvent;
import org.bukkit.plugin.java.JavaPlugin;

import ru.tehkode.permissions.PermissionUser;
import ru.tehkode.permissions.bukkit.PermissionsEx;

public final class CreeperCraft extends JavaPlugin implements Listener {

    @Override
    public void onEnable() {
        getServer().getPluginManager().registerEvents(this, this);
        getServer().getScheduler().scheduleSyncRepeatingTask(this, () -> {
            for (Player onlinePlayer : getServer().getOnlinePlayers()) {
                updatePlayerDisplayName(onlinePlayer);
            }
        }, getSecondsAsTicks(5), getSecondsAsTicks(5));
    }

    @Override
    public void onDisable() {
        getServer().getScheduler().cancelAllTasks();
    }

    @EventHandler
    public void onPlayerJoinEvent(PlayerJoinEvent playerJoinEvent) {
        Player player = playerJoinEvent.getPlayer();
        updatePlayerDisplayName(player);
    }

    private void updatePlayerDisplayName(Player player) {
        PermissionUser permissionUser = PermissionsEx.getPermissionManager().getUser(player);
        String displayName = ChatColor.translateAlternateColorCodes('&', String.format("%s%s%s&r", permissionUser.getPrefix(), player.getName(), permissionUser.getSuffix()));
        if (!player.getDisplayName().equals(displayName)) {
            player.setDisplayName(displayName);
            player.setPlayerListName(displayName);
        }
    }

    private long getSecondsAsTicks(long seconds) {
        return 20 * seconds;
    }
}
