package ${package}.recipe;
<#compress>

<#assign pureIO = []>
<#assign varsIO = []>

<#list data.slotList as slot>
    <#if slot.type == "Item">
        <#if slot.io == "Input">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#if slot.singleItem>
                <#if slot.optional>
                    <#assign varsIO += ["Optional<Ingredient> ${slot.name}${slot.type}${slot.io}"]>
                <#else>
                    <#assign varsIO += ["Ingredient ${slot.name}${slot.type}${slot.io}"]>
                </#if>
            <#else>
                <#if slot.optional>
                    <#assign varsIO += ["Optional<SizedIngredient> ${slot.name}${slot.type}${slot.io}"]>
                <#else>
                    <#assign varsIO += ["SizedIngredient ${slot.name}${slot.type}${slot.io}"]>
                </#if>
            </#if>
        <#elseif slot.io == "Output">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#if slot.optional>
                <#assign varsIO += ["Optional<ItemStack> ${slot.name}${slot.type}${slot.io}"]>
            <#else>
                <#assign varsIO += ["ItemStack ${slot.name}${slot.type}${slot.io}"]>
            </#if>
        </#if>
    <#elseif slot.type == "Fluid">
        <#if slot.io == "Input">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#if slot.optional>
                <#assign varsIO += ["Optional<SizedFluidIngredient> ${slot.name}${slot.type}${slot.io}"]>
            <#else>
                <#assign varsIO += ["SizedFluidIngredient ${slot.name}${slot.type}${slot.io}"]>
            </#if>
        <#elseif slot.io == "Output">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#if slot.optional>
                <#assogn varsIO += ["Optional<FluidStack> ${slot.name}${slot.type}${slot.io}"]>
            <#else>
                <#assign varsIO += ["FluidStack ${slot.name}${slot.type}${slot.io}"]>
            </#if>
        </#if>
    <#elseif slot.type == "Logic">
        <#if slot.io == "Input">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#assign varsIO += ["boolean ${slot.name}${slot.type}${slot.io}"]>
        <#elseif slot.io == "Output">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#assign varsIO += ["boolean ${slot.name}${slot.type}${slot.io}"]>
        </#if>
    <#elseif slot.type == "Number">
        <#if slot.io == "Input">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#assign varsIO += ["double ${slot.name}${slot.type}${slot.io}"]>
        <#elseif slot.io == "Output">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#assign varsIO += ["double ${slot.name}${slot.type}${slot.io}"]>
        </#if>
    <#elseif slot.type == "Text">
        <#if slot.io == "Input">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#assign varsIO += ["String ${slot.name}${slot.type}${slot.io}"]>
        <#elseif slot.io == "Output">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#assign varsIO += ["String ${slot.name}${slot.type}${slot.io}"]>
        </#if>
    </#if>
</#list>

import java.util.Optional;
import java.util.List;
import javax.annotation.Nullable;

public record ${name}Recipe(${varsIO?join(", ")}) implements Recipe<RecipeInput> {
    public @NotNull ItemStack getItemStackResult(String output) {
        <#list data.slotList as slot>
            <#if slot.io == "Output" && slot.type == "Item">
                <#if slot.optional>
                    if(output.equals("${slot.name}") && ${slot.name}${slot.type}${slot.io}.isPresent()) {
                        return ${slot.name}${slot.type}${slot.io}.get();
                    }
                <#else>
                    if(output.equals("${slot.name}")) {
                        return ${slot.name}${slot.type}${slot.io};
                    }
                </#if>
            </#if>
        </#list>
        return ItemStack.EMPTY;
    }

    public @NotNull FluidStack getFluidStackResult(String output) {
        <#list data.slotList as slot>
            <#if slot.io == "Output" && slot.type == "Fluid">
                <#if slot.optional>
                    if(output.equals("${slot.name}") && ${slot.name}${slot.type}${slot.io}.isPresent()) {
                        return ${slot.name}${slot.type}${slot.io}.get();
                    }
                <#else>
                    if(output.equals("${slot.name}")) {
                        return ${slot.name}${slot.type}${slot.io};
                    }
                </#if>
            </#if>
        </#list>
        return FluidStack.EMPTY;
    }

    public @NotNull boolean getBooleanResult(String output) {
        <#list data.slotList as slot>
            <#if slot.io == "Output" && slot.type == "Logic">
                if(output.equals("${slot.name}")) {
                    return ${slot.name}${slot.type}${slot.io};
                }
            </#if>
        </#list>
        return false;
    }

    public @NotNull double getDoubleResult(String output) {
        <#list data.slotList as slot>
            <#if slot.io == "Output" && slot.type == "Number">
                if(output.equals("${slot.name}")) {
                    return ${slot.name}${slot.type}${slot.io};
                }
            </#if>
        </#list>
        return 0.0d;
    }

    public @NotNull String getStringResult(String output) {
        <#list data.slotList as slot>
            <#if slot.io == "Output" && slot.type == "Text">
                if(output.equals("${slot.name}")) {
                    return ${slot.name}${slot.type}${slot.io};
                }
            </#if>
        </#list>
        return "";
    }

    // JeiI: Validates a recipe ingredient with it's given recipe input
	public boolean validate(Object given, Object recipe) {
		// Test Item
		if(given instanceof ItemStack item) {
			if(recipe instanceof SizedIngredient sIngre) {
				return sIngre.test(item);
			} else if(recipe instanceof Ingredient ingre) {
			    return ingre.test(item);
			} else if(recipe instanceof Optional<?> opt) {
				if(item.isEmpty()) {
					return opt.isEmpty();
				}

                if(opt.isPresent()) {
				    Object o = opt.get();
				    if(o instanceof SizedIngredient sIngred) {
					    return sIngred.test(item);
				    } else if(o instanceof Ingredient ingred) {
				        return ingred.test(item);
				    }
                }

				return false;
			}
		}

		// Test Fluid
		if(given instanceof FluidStack fluid) {
			if(recipe instanceof SizedFluidIngredient ingre) {
				return ingre.test(fluid);
			} else if(recipe instanceof Optional<?> opt) {
				if(fluid.isEmpty()) {
					return opt.isEmpty();
				}

                if(opt.isPresent()) {
				    Object o = opt.get();
				    if(o instanceof SizedFluidIngredient ingred) {
					    return ingred.test(fluid);
				    }
                }

				return false;
			}
		}

		// Test boolean
		if(given instanceof Boolean bool && recipe instanceof Boolean rec) {
			return bool.equals(rec);
		}

		// Test double
		if(given instanceof double[] doub && recipe instanceof Double rec) {
			return doub[0] >= rec;
		}

		// Test String
		if(given instanceof String str && recipe instanceof String rec) {
			return str.equals(rec);
		}

		return false;
	}

    // JeiI: returns the recipe ingredient amount
	public int amount(Object recipe) {
        if(recipe instanceof SizedIngredient sized) {
            return sized.count();
        } else if(recipe instanceof Ingredient) {
            return 1;
        } else if(recipe instanceof Optional<?> opt) {
            if(opt.isPresent()) {
                Object o = opt.get();
                if(o instanceof SizedIngredient sizedO) {
                    return sizedO.count();
                } else if(o instanceof Ingredient) {
                    return 1;
                }
            }
        }

        if(recipe instanceof SizedFluidIngredient sizedF) {
            return sizedF.amount();
        } else if(recipe instanceof Optional<?> opt) {
            if(opt.isPresent()) {
                Object o = opt.get();
                if(o instanceof SizedFluidIngredient sizedFO) {
                    return sizedFO.amount();
                }
            }
        }

        if(recipe instanceof Double doub) {
            return doub.intValue();
        }

        return 0;
	}

    @Override
    public @NotNull RecipeSerializer<? extends Recipe<RecipeInput>> getSerializer() {
        return Serializer.INSTANCE;
    }

    @Override
    public @NotNull RecipeType<? extends Recipe<RecipeInput>> getType() {
        return Type.INSTANCE;
    }

    public static class Type implements RecipeType<${name}Recipe> {
        private Type(){}
        public static final RecipeType<${name}Recipe> INSTANCE = new Type();
    }

    public static class Serializer implements RecipeSerializer<${name}Recipe> {
        public static final Serializer INSTANCE = new Serializer();

        public final MapCodec<${name}Recipe> CODEC = RecordCodecBuilder.mapCodec(instance ->
            instance.group(
                <#assign ingre = []>

                <#list data.slotList as slot>
                    <#if slot.type == "Item">
                        <#if slot.io == "Input">
                            <#if slot.singleItem>
                                <#if slot.optional>
                                    <#assign ingre += ["Ingredient.CODEC.optionalFieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                                <#else>
                                    <#assign ingre += ["Ingredient.CODEC.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                                </#if>
                            <#else>
                                <#if slot.optional>
                                    <#assign ingre += ["SizedIngredient.NESTED_CODEC.optionalFieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                                <#else>
                                    <#assign ingre += ["SizedIngredient.NESTED_CODEC.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                                </#if>
                            </#if>
                        <#elseif slot.io == "Output">
                            <#if slot.optional>
                                <#assign ingre += ["ItemStack.CODEC.optionalFieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            <#else>
                                <#assign ingre += ["ItemStack.CODEC.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            </#if>
                        </#if>
                    <#elseif slot.type == "Fluid">
                        <#if slot.io == "Input">
                            <#if slot.optional>
                                <#assign ingre += ["SizedFluidIngredient.CODEC.optionalFieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            <#else>
                                <#assign ingre += ["SizedFluidIngredient.CODEC.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            </#if>
                        <#elseif slot.io == "Output">
                            <#if slot.optional>
                                <#assign ingre += ["FluidStack.CODEC.optionalFieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            <#else>
                                <#assign ingre += ["FluidStack.CODEC.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                            </#if>
                        </#if>
                    <#elseif slot.type == "Logic">
                        <#if slot.optional>
                            <#assign ingre += ["Codec.BOOL.optionalFieldOf(\"${slot.name}\", ${slot.defaultBoolean}).forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        <#else>
                            <#assign ingre += ["Codec.BOOL.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        </#if>
                    <#elseif slot.type == "Number">
                        <#if slot.optional>
                            <#assign ingre += ["Codec.DOUBLE.optionalFieldOf(\"${slot.name}\", ${slot.defaultDouble}d).forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        <#else>
                            <#assign ingre += ["Codec.DOUBLE.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        </#if>
                    <#elseif slot.type == "Text">
                        <#if slot.optional>
                            <#assign ingre += ["Codec.STRING.optionalFieldOf(\"${slot.name}\", ${slot.defaultString}).forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        <#else>
                            <#assign ingre += ["Codec.STRING.fieldOf(\"${slot.name}\").forGetter(${name}Recipe::${slot.name}${slot.type}${slot.io})"]>
                        </#if>
                    </#if>
                </#list>

                ${ingre?join(", ")}
            ).apply(instance, Serializer::create${name}Recipe)
        );

        private static final StreamCodec<RegistryFriendlyByteBuf, ${name}Recipe> STREAM_CODEC = StreamCodec.of(
            Serializer::write,
            Serializer::read
        );

        @Override
        public @NotNull MapCodec<${name}Recipe> codec() {
            return CODEC;
        }

        @Override
        public @NotNull StreamCodec<RegistryFriendlyByteBuf, ${name}Recipe> streamCodec() {
            return STREAM_CODEC;
        }

        private static ${name}Recipe read(RegistryFriendlyByteBuf buffer) {
            <#list data.slotList as slot>
                <#if slot.type == "Item">
                    <#if slot.io == "Input">
                        <#if slot.singleItem>
                            <#if slot.optional>
                                Optional<Ingredient> ${slot.name}${slot.type}${slot.io} = ByteBufCodecs.optional(Ingredient.CONTENTS_STREAM_CODEC).decode(buffer);
                            <#else>
                                Ingredient ${slot.name}${slot.type}${slot.io} = Ingredient.CONTENTS_STREAM_CODEC.decode(buffer);
                            </#if>
                        <#else>
                            <#if slot.optional>
                                Optional<SizedIngredient> ${slot.name}${slot.type}${slot.io} = ByteBufCodecs.optional(SizedIngredient.STREAM_CODEC).decode(buffer);
                            <#else>
                                SizedIngredient ${slot.name}${slot.type}${slot.io} = SizedIngredient.STREAM_CODEC.decode(buffer);
                            </#if>
                        </#if>
                    <#elseif slot.io == "Output">
                        <#if slot.optional>
                            Optional<ItemStack> ${slot.name}${slot.type}${slot.io} = ByteBufCodecs.optional(ItemStack.STREAM_CODEC).decode(buffer);
                        <#else>
                            ItemStack ${slot.name}${slot.type}${slot.io} = ItemStack.STREAM_CODEC.decode(buffer);
                        </#if>
                    </#if>
                <#elseif slot.type == "Fluid">
                    <#if slot.io == "Input">
                        <#if slot.optional>
                            Optional<SizedFluidIngredient> ${slot.name}${slot.type}${slot.io} = ByteBufCodecs.optional(SizedFluidIngredient.STREAM_CODEC).decode(buffer);
                        <#else>
                            SizedFluidIngredient ${slot.name}${slot.type}${slot.io} = SizedFluidIngredient.STREAM_CODEC.decode(buffer);
                        </#if>
                    <#elseif slot.io == "Output">
                        <#if slot.optional>
                            Optional<FluidStack> ${slot.name}${slot.type}${slot.io} = ByteBufCodecs.optional(FluidStack.STREAM_CODEC).decode(buffer);
                        <#else>
                            FluidStack ${slot.name}${slot.type}${slot.io} = FluidStack.STREAM_CODEC.decode(buffer);
                        </#if>
                    </#if>
                <#elseif slot.type == "Logic">
                    boolean ${slot.name}${slot.type}${slot.io} = buffer.readBoolean();
                <#elseif slot.type == "Number">
                    double ${slot.name}${slot.type}${slot.io} = buffer.readDouble();
                <#elseif slot.type == "Text">
                    String ${slot.name}${slot.type}${slot.io} = buffer.readUtf();
                </#if>
            </#list>
            return new ${name}Recipe(${pureIO?join(", ")});
        }

        private static void write(RegistryFriendlyByteBuf buffer, ${name}Recipe recipe) {
            <#list data.slotList as slot>
                <#if slot.type == "Item">
                    <#if slot.io == "Input">
                        <#if slot.singleItem>
                            <#if slot.optional>
                                ByteBufCodecs.optional(Ingredient.CONTENTS_STREAM_CODEC).encode(buffer, recipe.${slot.name}${slot.type}${slot.io}());
                            <#else>
                                Ingredient.CONTENTS_STREAM_CODEC.encode(buffer, recipe.${slot.name}${slot.type}${slot.io}());
                            </#if>
                        <#else>
                            <#if slot.optional>
                                ByteBufCodecs.optional(SizedIngredient.STREAM_CODEC).encode(buffer, recipe.${slot.name}${slot.type}${slot.io}());
                            <#else>
                                SizedIngredient.STREAM_CODEC.encode(buffer, recipe.${slot.name}${slot.type}${slot.io}());
                            </#if>
                        </#if>
                    <#elseif slot.io == "Output">
                        <#if slot.optional>
                            ByteBufCodecs.optional(ItemStack.STREAM_CODEC).encode(buffer, recipe.${slot.name}${slot.type}${slot.io}());
                        <#else>
                            ItemStack.STREAM_CODEC.encode(buffer, recipe.${slot.name}${slot.type}${slot.io}());
                        </#if>
                    </#if>
                <#elseif slot.type == "Fluid">
                    <#if slot.io == "Input">
                        <#if slot.optional>
                            ByteBufCodecs.optional(SizedFluidIngredient.STREAM_CODEC).encode(buffer, recipe.${slot.name}${slot.type}${slot.io}());
                        <#else>
                            SizedFluidIngredient.STREAM_CODEC.encode(buffer, recipe.${slot.name}${slot.type}${slot.io}());
                        </#if>
                    <#elseif slot.io == "Output">
                        <#if slot.optional>
                            ByteBufCodecs.optional(FluidStack.STREAM_CODEC).encode(buffer, recipe.${slot.name}${slot.type}${slot.io}());
                        <#else>
                            FluidStack.STREAM_CODEC.encode(buffer, recipe.${slot.name}${slot.type}${slot.io}());
                        </#if>
                    </#if>
                <#elseif slot.type == "Logic">
                    buffer.writeBoolean(recipe.${slot.name}${slot.type}${slot.io}());
                <#elseif slot.type == "Number">
                    buffer.writeDouble(recipe.${slot.name}${slot.type}${slot.io}());
                <#elseif slot.type == "Text">
                    buffer.writeUtf(recipe.${slot.name}${slot.type}${slot.io}());
                </#if>
            </#list>
        }

        static ${name}Recipe create${name}Recipe(${varsIO?join(", ")}) {
            return new ${name}Recipe(${pureIO?join(", ")});
        }
    }

    // Unused
    @Override
    public boolean matches(@NotNull RecipeInput pContainer, @NotNull Level Level) {
        return false;
    }

    // Unused
    @Override
    public ItemStack assemble(@NotNull RecipeInput input, @NotNull HolderLookup.Provider holder) {
        return ItemStack.EMPTY;
    }

    // Unused
    @Override
    public PlacementInfo placementInfo() {
        List<Optional<SizedIngredient>> sized = new ArrayList<>();
        <#list data.slotList as slot>
            <#if slot.io == "Input" && slot.type == "Item" && !slot.singleItem>
                <#if slot.optional>
                    sized.add(${slot.name}${slot.type}${slot.io}());
                <#else>
                    sized.add(Optional.of(${slot.name}${slot.type}${slot.io}()));
                </#if>
            </#if>
        </#list>
        if(!sized.isEmpty()) {
            List<Optional<Ingredient>> ingre = sized.stream().map(opt -> opt.map(SizedIngredient::ingredient)).toList();
            return PlacementInfo.createFromOptionals(ingre);
        }
        return PlacementInfo.NOT_PLACEABLE;
    }

    // Unused
    @Override
    public RecipeBookCategory recipeBookCategory() {
        return RecipeBookCategories.CRAFTING_MISC;
    }
}</#compress>