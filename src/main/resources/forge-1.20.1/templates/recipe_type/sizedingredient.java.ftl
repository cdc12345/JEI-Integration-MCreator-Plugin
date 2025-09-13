package ${package}.utils;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

import javax.annotation.Nullable;

/**
 * SizedIngredient
 *
 * A ported version of the SizedIngredient class from
 * Neoforge 1.21.1 for Forge 1.20.1
 */
public class SizedIngredient {
	private final Ingredient ingredient;
	private final int count;
	@Nullable
	private ItemStack[] cachedStacks;

	public SizedIngredient(Ingredient ingredient, int count) {
		if (count <= 0) {
			throw new IllegalArgumentException("Count must be positive");
		}
		this.ingredient = ingredient;
		this.count = count;
	}

	public static final SizedIngredient EMPTY = new SizedIngredient(Ingredient.EMPTY, 1);

	public Ingredient getIngredient() {
		return ingredient;
	}

	public int getCount() {
		return count;
	}

    /**
     * Helper method to create a simple SizedIngredient that matches a single item.
     */
	public static SizedIngredient of(ItemLike item, int count) {
		return new SizedIngredient(Ingredient.of(item), count);
	}

    /**
     * Helper method to create a simple SizedIngredient that matches items in a tag.
     */
	public static SizedIngredient of(TagKey<Item> tag, int count) {
		return new SizedIngredient(Ingredient.of(tag), count);
	}

    /**
     * Performs a size-sensitive test on the given stack.
     *
     * @return {@code true} if the stack matches the ingredient and has at least the required count.
     */
	public boolean test(ItemStack stack) {
		return ingredient.test(stack) && stack.getCount() >= count;
	}

    /**
     * Returns a list of the stacks from this {@link #ingredient}, with an updated {@link #count}.
     *
     * @implNote the array is cached and should not be modified, just like {@link Ingredient#getItems()}.
     */
	public ItemStack[] getItems() {
		if (cachedStacks == null) {
			cachedStacks = Stream.of(ingredient.getItems()).map(item -> item.copyWithCount(count)).toArray(ItemStack[]::new);
		}
		return cachedStacks;
	}

	/**
	 * Custom method to read the SizedIngredient from the recipe
	 */
	public static SizedIngredient fromJson(JsonObject recipe, String recipeKey, boolean optional) {
	    if(!recipe.has(recipeKey) && optional) {
	        return SizedIngredient.EMPTY;
	    } else if(recipe.has(recipeKey)) {
	        JsonObject json = GsonHelper.getAsJsonObject(recipe, recipeKey);

		    Ingredient ingredient = Ingredient.fromJson(json);
		    int count = GsonHelper.getAsInt(json, "count", 1);
		    return new SizedIngredient(ingredient, count);
		} else if(!recipe.has(recipeKey) && !optional) {
		    throw new JsonSyntaxException("Missing '" + recipeKey + "', expected to find a JsonObject");
		}
		return SizedIngredient.EMPTY;
	}

	/**
	 * Custom method to read from the FriendlyByteBuf
	 */
	public static SizedIngredient fromNetwork(FriendlyByteBuf buf) {
		Ingredient ingredient = Ingredient.fromNetwork(buf);
		int count = buf.readVarInt();
		return new SizedIngredient(ingredient, count);
	}

	/**
	 * Custom method to write to the FriendlyByteBuf
	 */
	public void toNetwork(FriendlyByteBuf buf) {
		ingredient.toNetwork(buf);
		buf.writeVarInt(count);
	}

	@Override
	public String toString() {
		return "SizedIngredient{" + count + "x " + ingredient + "}";
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (!(o instanceof SizedIngredient other))
			return false;
		return count == other.count && ingredient.equals(other.ingredient);
	}

	@Override
	public int hashCode() {
		return Objects.hash(ingredient, count);
	}
}
