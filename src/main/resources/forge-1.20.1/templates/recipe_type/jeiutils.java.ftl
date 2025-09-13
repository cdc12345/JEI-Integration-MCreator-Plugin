/**
 * Copyright (c) 2025 zSemper
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the MIT License
 */

package ${package}.utils;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import com.google.gson.JsonSyntaxException;


import java.util.Objects;

/**
 * JEIUtils
 *
 * Helper Class for Just Enough Recipes Plugin
 *
 * Contains methods for recipe reading, serialization and validation
 */
public class JEIUtils {
	private JEIUtils() {}

	/**
	 * Method for testing a given input with an input from the recipe
	 *
	 * @param given		the input in custom code
	 * @param recipe	the input in the recipe
	 *
	 * @return <code>true</code> if both Objects match
	 */
	public static boolean validate(Object given, Object recipe) {

		// Validate Items
		if (given instanceof ItemStack item && recipe instanceof SizedIngredient ingre) {
			if (item.isEmpty()) {
				return ingre.getIngredient().isEmpty();
			}
			return ingre.test(item);
		}

		// Validate Fluids
		if (given instanceof FluidStack fluid && recipe instanceof FluidStack stack) {
			if(fluid.isEmpty()) {
				return stack.isEmpty();
			}
			return fluid.getFluid() == stack.getFluid() && fluid.getAmount() >= stack.getAmount();
		}

		// Validate Booleans
		if (given instanceof Boolean bool && recipe instanceof Boolean rec) {
			return bool.equals(rec);
		}

		// Validate Doubles
		if (given instanceof Double doub && recipe instanceof Double rec) {
			return doub.equals(rec);
		}

		// Validate Strings
		if (given instanceof String str && recipe instanceof String rec) {
			return str.equals(rec);
		}
		return false;
	}

	/**
	 * JEISerialization
	 *
	 * Class for reading recipes
	 *
	 * Built upon {@code net.minecraftforge.common.crafting.CraftingHelper} and extended to fluids
	 */
	public static class JEISerialization {
		private static final JEISerialization INSTANCE = new JEISerialization();

		private JEISerialization() {}

		public static JEISerialization getInstance() {
			return INSTANCE;
		}

		/**
		 * Method for reading the ItemStack from a given recipe
		 *
		 * @param recipe	the recipe as a JsonObject
		 * @param recipeKey the key where the ItemStack is provided in the recipe
		 * @param optional  if <code>true</code> allows item to be air
		 *
		 * @return the ItemStack given in the recipe
		 */
		public static ItemStack getItemStack(JsonObject recipe, String recipeKey, boolean optional) {
			if(!recipe.has(recipeKey) && optional) {
				return new ItemStack(Items.AIR, 1);
			} else if(recipe.has(recipeKey)) {
				JsonObject json = GsonHelper.getAsJsonObject(recipe, recipeKey);

                Item item = getItem(GsonHelper.getAsString(json, "item"), optional);
                int itemCount = GsonHelper.getAsInt(json, "count", 1);

                return new ItemStack(item, itemCount);
			} else if(!recipe.has(recipeKey) && !optional) {
				throw new JsonSyntaxException("Missing '" + recipeKey + "', expected to find a JsonObject");
			}
			return ItemStack.EMPTY;
		}


		/**
		 * Method for reading the FluidStack from a given recipe
		 *
		 * @param recipe 	the recipe as a JsonObject
		 * @param recipeKey the key where the FluidStack is provided in the recipe
		 * @param optional  if <code>true</code> allows fluid to be empty
		 *
		 * @return the FluidStack given in the recipe
		 */
		public static FluidStack getFluidStack(JsonObject recipe, String recipeKey, boolean optional) {
		    if(!recipe.has(recipeKey) && optional) {
		        return new FluidStack(Fluids.EMPTY, 1);
		    } else if(recipe.has(recipeKey)) {
			    JsonObject json = GsonHelper.getAsJsonObject(recipe, recipeKey);

			    Fluid fluid = getFluid(GsonHelper.getAsString(json, "fluid"), optional);
			    int fluidCount = GsonHelper.getAsInt(json, "amount", 1);

			    return new FluidStack(fluid, fluidCount);
			} else if(!recipe.has(recipeKey) && !optional) {
			   throw new JsonSyntaxException("Missing '" + recipeKey + "', expected to find a JsonObject");
			}
			return FluidStack.EMPTY;
		}

		/**
		 * Helper method for retrieving the item connected to an item name
		 *
		 * @param itemName	the name of the item it is registered under
		 * @param optional  if <code>true</code> allows item to be air, otherwise throw Exception
		 *
		 * @return the item the itemName is connected to
		 */
		private static Item getItem(String itemName, boolean optional) {
			ResourceLocation itemKey = new ResourceLocation(itemName);

			if (!ForgeRegistries.ITEMS.containsKey(itemKey)) {
				throw new JsonSyntaxException("Unknown item '" + itemName + "'");
			}

			Item item = Objects.requireNonNull(ForgeRegistries.ITEMS.getValue(itemKey));
			if(!optional && item == Items.AIR) {
				throw new JsonSyntaxException("Invalid item '" + itemName + "'");
			}

			return item;
		}

		/**
		 * Helper method for retrieving the fluid connected to a fluid name
		 *
		 * @param fluidName	the name of the fluid is is registered under
		 * @param optional  if <code>true</code> allows fluid to be empty, otherwise throw Exception
		 *
		 * @return the fluid the fluidName if connected to
		 */
		private static Fluid getFluid(String fluidName, boolean optional) {
			ResourceLocation fluidKey = new ResourceLocation(fluidName);

			if (!ForgeRegistries.FLUIDS.containsKey(fluidKey)) {
				throw new JsonSyntaxException("Unknown fluid '" + fluidName + "'");
			}

			Fluid fluid = Objects.requireNonNull(ForgeRegistries.FLUIDS.getValue(fluidKey));

			if(!optional && fluid == Fluids.EMPTY) {
				throw new JsonSyntaxException("Invalid fluid '" + fluidName + "'");
			}

			return fluid;
		}

		/**
		 * Method for reading the boolean from a given recipe
		 *
		 * @param recipe 		the recipe as a JsonObject
		 * @param recipeKey 	the key where the boolean is provided in the recipe
		 * @param optional  	if <code>true</code> allows boolean to be empty
		 * @param defaultValue	the default value if the recipeKey does not exist
		 *
		 * @return the boolean given in the recipe
		 */
		public static boolean getBoolean(JsonObject recipe, String recipeKey, boolean optional, boolean defaultValue) {
			if(!recipe.has(recipeKey) && optional) {
				return defaultValue;
			} else if(recipe.has(recipeKey)) {
				return recipe.get(recipeKey).getAsBoolean();
			} else if(!recipe.has(recipeKey) && !optional) {
				throw new JsonSyntaxException("Missing '" + recipeKey + "', expected to find a JsonProperty");
			}
			return false;
		}

		/**
		 * Method for reading the double from a given recipe
		 *
		 * @param recipe 		the recipe as a JsonObject
		 * @param recipeKey 	the key where the double is provided in the recipe
		 * @param optional  	if <code>true</code> allows double to be empty
		 * @param defaultValue	the default value if the recipeKey does not exist
		 *
		 * @return the double given in the recipe
		 */
		public static double getDouble(JsonObject recipe, String recipeKey, boolean optional, double defaultValue) {
			if(!recipe.has(recipeKey) && optional) {
				return defaultValue;
			} else if(recipe.has(recipeKey)) {
				return recipe.get(recipeKey).getAsDouble();
			} else if(!recipe.has(recipeKey) && !optional) {
				throw new JsonSyntaxException("Missing '" + recipeKey + "', expected to find a JsonProperty");
			}
			return 0d;
		}

		/**
		 * Method for reading the String from a given recipe
		 *
		 * @param recipe 		the recipe as a JsonObject
		 * @param recipeKey 	the key where the String is provided in the recipe
		 * @param optional  	if <code>true</code> allows String to be empty
		 * @param defaultValue	the default value if the recipeKey does not exist
		 *
		 * @return the String given in the recipe
		 */
		public static String getString(JsonObject recipe, String recipeKey, boolean optional, String defaultValue) {
			if(!recipe.has(recipeKey) && optional) {
				return defaultValue;
			} else if(recipe.has(recipeKey)) {
				return recipe.get(recipeKey).getAsString();
			} else if(!recipe.has(recipeKey) && !optional) {
				throw new JsonSyntaxException("Missing '" + recipeKey + "', expected to find a JsonProperty");
			}
			return "";
		}
	}

	/**
	 * JEIByteBuf
	 *
	 * Class for networking of recipies from and to the {@code net.minecraft.network.FriendlyByteBuf}
	 *
	 * Extended to make the recipe networking as simple and resource effiecient as possible
	 */
	public class JEIByteBuffer extends FriendlyByteBuf {
		private JEIByteBuffer(ByteBuf buf) {
			super(buf);
		}

		/**
		 * Used to read an ItemStack from the FriendlyByteBuf
		 *
		 * @return the ItemStack in the FriendlyByteBuf
		 */
		public ItemStack readItemStack() {
			if (!this.readBoolean()) {
				return ItemStack.EMPTY;
			} else {
				Item item = this.readById(BuiltInRegistries.ITEM);
				int count = this.readByte();
				ItemStack stack = new ItemStack(item, count);
				stack.readShareTag(this.readNbt());
				return stack;
			}
		}

		/**
		 * Used to write an ItemStack to the FriendlyByteBuf
		 *
		 * @param stack		the ItemStack that is written to the FriendlyByteBuf
		 *
		 * @return the FriendlyByteBuf with the ItemStack written to it
		 */
		public FriendlyByteBuf writeItemStack(ItemStack stack) {
			if (stack.isEmpty()) {
				this.writeBoolean(false);
			} else {
				this.writeBoolean(true);

				Item item = stack.getItem();
				this.writeId(BuiltInRegistries.ITEM, item);
				this.writeByte(stack.getCount());

				CompoundTag tag = null;
				if (item.isDamageable(stack) || item.shouldOverrideMultiplayerNbt()) {
					tag = stack.getShareTag();
				}
				this.writeNbt(tag);
			}
			return this;
		}

		/**
		 * Used to read a FluidStack from the FriendlyByteBuf
		 *
		 * @return the FluidStack in the FriendlyByteBuf
		 */
		public FluidStack readFluidStack() {
			if (!this.readBoolean()) {
				return FluidStack.EMPTY;
			} else {
				Fluid fluid = this.readById(BuiltInRegistries.FLUID);
				int amount = this.readByte();

				return new FluidStack(fluid, amount);
			}
		}

		/**
		 * Used to write a FluidStack to the FriendlyByteBuf
		 *
		 * @param stack		the FluidStack that is written of the FriendlyByteBuf
		 *
		 * @return the FriendlyByteBuf with the FluidStack written to it
		 */
		public FriendlyByteBuf writeFluidStacks(FluidStack stack) {
			if (stack.isEmpty()) {
				this.writeBoolean(false);
			} else {
				this.writeBoolean(true);

				Fluid fluid = stack.getFluid();
				this.writeId(BuiltInRegistries.FLUID, fluid);
				this.writeByte(stack.getAmount());
			}
			return this;
		}
	}
}
