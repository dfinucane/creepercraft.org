package org.creepercraft.apocalypse;

import org.bukkit.Location;
import org.bukkit.Material;
import org.bukkit.enchantments.Enchantment;
import org.bukkit.entity.Player;
import org.bukkit.entity.Zombie;
import org.bukkit.entity.Skeleton;
import org.bukkit.inventory.ItemStack;
import org.bukkit.plugin.java.JavaPlugin;
import org.bukkit.scheduler.BukkitRunnable;

public class EvilSpawner extends BukkitRunnable {

    private final JavaPlugin javaPlugin;

    public EvilSpawner(JavaPlugin javaPlugin) {
        this.javaPlugin = javaPlugin;
    }

    public void run() {
        for (Player player : this.javaPlugin.getServer().getOnlinePlayers()) {
            javaPlugin.getLogger().info(String.format("Evil has come to %s.", player.getName()));
            spawnZombies(player);
            spawnSkeletons(player);
        }
    }

    private void spawnZombies(Player player) {
        final long blocksFromPlayer = 3;
        Location playerLocation = player.getLocation();
        Zombie zombie = player.getWorld().spawn(playerLocation.clone().add(blocksFromPlayer, 0, 0), Zombie.class);
        zombie.getEquipment().setHelmet(new ItemStack(Material.GOLD_HELMET));
        zombie = player.getWorld().spawn(playerLocation.clone().add(0, 0, blocksFromPlayer), Zombie.class);
        zombie.getEquipment().setHelmet(new ItemStack(Material.GOLD_HELMET));
        zombie = player.getWorld().spawn(playerLocation.clone().add(-blocksFromPlayer, 0, 0), Zombie.class);
        zombie.getEquipment().setHelmet(new ItemStack(Material.GOLD_HELMET));
        zombie = player.getWorld().spawn(playerLocation.clone().add(0, 0, -blocksFromPlayer), Zombie.class);
        zombie.getEquipment().setHelmet(new ItemStack(Material.GOLD_HELMET));
    }

    private void spawnSkeletons(Player player) {
        final long blocksFromPlayer = 5;
        Location playerLocation = player.getLocation();
        addFullIronArmor(player.getWorld().spawn(playerLocation.clone().add(blocksFromPlayer, 0, 0), Skeleton.class));
        addFullIronArmor(player.getWorld().spawn(playerLocation.clone().add(0, 0, blocksFromPlayer), Skeleton.class));
        addFullIronArmor(player.getWorld().spawn(playerLocation.clone().add(-blocksFromPlayer, 0, 0), Skeleton.class));
        addFullIronArmor(player.getWorld().spawn(playerLocation.clone().add(0, 0, -blocksFromPlayer), Skeleton.class));
    }

    private void addFullIronArmor(Skeleton skeleton) {
        skeleton.getEquipment().setHelmet(new ItemStack(Material.IRON_HELMET));
        skeleton.getEquipment().setChestplate(new ItemStack(Material.IRON_CHESTPLATE));
        skeleton.getEquipment().setBoots(new ItemStack(Material.IRON_BOOTS));
        ItemStack enchantedBow = new ItemStack(Material.BOW);
        enchantedBow.addEnchantment(Enchantment.ARROW_DAMAGE, 1);
        skeleton.getEquipment().setItemInMainHand(enchantedBow);
    }
}