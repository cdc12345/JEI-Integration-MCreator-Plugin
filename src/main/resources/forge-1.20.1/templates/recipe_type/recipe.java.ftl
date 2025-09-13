package ${package}.recipe;

<#compress>

<#assign pureIO = []>
<#assign varsIO = []>

<#list data.slotList as slot>
    <#if slot.type == "Item">
        <#if slot.io == "Input">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#assign varsIO += ["SizedIngredient ${slot.name}${slot.type}${slot.io}"]>
        <#elseif slot.io == "Output">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#assign varsIO += ["ItemStack ${slot.name}${slot.type}${slot.io}"]>
        </#if>
    <#elseif slot.type == "Fluid">
        <#if slot.io == "Input">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#assign varsIO += ["FluidStack ${slot.name}${slot.type}${slot.io}"]>
        <#elseif slot.io == "Output">
            <#assign pureIO += ["${slot.name}${slot.type}${slot.io}"]>
            <#assign varsIO += ["FluidStack ${slot.name}${slot.type}${slot.io}"]>
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

import javax.annotation.Nullable;
import com.google.gson.JsonObject;

public record ${name}Recipe(ResourceLocation res, ${varsIO?join(", ")}) implements Recipe<SimpleContainer> {
    public @NotNull ItemStack getItemStackResult(String output) {
        <#list data.slotList as slot>
            <#if slot.io == "Output" && slot.type == "Item">
                if(output.equals("${slot.name}")) {
                    return ${slot.name}${slot.type}${slot.io};
                }
            </#if>
        </#list>
        return ItemStack.EMPTY;
    }

    public @NotNull FluidStack getFluidStackResult(String output) {
        <#list data.slotList as slot>
            <#if slot.io == "Output" && slot.type == "Fluid">
                if(output.equals("${slot.name}")) {
                    return ${slot.name}${slot.type}${slot.io};
                }
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

    @Override
    public ResourceLocation getId() {
        return res;
    }

    @Override
    public @NotNull RecipeSerializer<?> getSerializer() {
        return Serializer.INSTANCE;
    }

    @Override
    public @NotNull RecipeType<?> getType() {
        return Type.INSTANCE;
    }

    public static class Type implements RecipeType<${name}Recipe> {
        private Type(){}
        public static final Type INSTANCE = new Type();
        public static final String ID = "${data.getModElement().getRegistryName()}";
    }

    public static class Serializer implements RecipeSerializer<${name}Recipe> {
        public static final Serializer INSTANCE = new Serializer();
        public static final ResourceLocation ID = new ResourceLocation("${modid}", "${data.getModElement().getRegistryName()}");

        @Override
        public ${name}Recipe fromJson(ResourceLocation res, JsonObject recipe) {
            JEIUtils.JEISerialization serialize = JEIUtils.JEISerialization.getInstance();

            <#list data.slotList as slot>
                <#if slot.type == "Item">
                    <#if slot.io == "Input">
                        <#if slot.optional>
                            SizedIngredient ${slot.name}${slot.type}${slot.io} = SizedIngredient.fromJson(recipe, "${slot.name}", true);
                        <#else>
                            SizedIngredient ${slot.name}${slot.type}${slot.io} = SizedIngredient.fromJson(recipe, "${slot.name}", false);
                        </#if>
                    <#elseif slot.io == "Output">
                        ItemStack ${slot.name}${slot.type}${slot.io} = serialize.getItemStack(recipe, "${slot.name}", false);
                    </#if>
                <#elseif slot.type == "Fluid">
                    <#if slot.io == "Input">
                        <#if slot.optional>
                            FluidStack ${slot.name}${slot.type}${slot.io} = serialize.getFluidStack(recipe, "${slot.name}", true);
                        <#else>
                            FluidStack ${slot.name}${slot.type}${slot.io} = serialize.getFluidStack(recipe, "${slot.name}", false);
                        </#if>
                    <#elseif slot.io == "Output">
                        FluidStack ${slot.name}${slot.type}${slot.io} = serialize.getFluidStack(recipe, "${slot.name}", false);
                    </#if>
                <#elseif slot.type == "Logic">
                    <#if slot.io == "Input">
                        <#if slot.optional>
                            boolean ${slot.name}${slot.type}${slot.io} = serialize.getBoolean(recipe, "${slot.name}", true, ${slot.defaultBoolean});
                        <#else>
                            boolean ${slot.name}${slot.type}${slot.io} = serialize.getBoolean(recipe, "${slot.name}", false, false);
                        </#if>
                    <#elseif slot.io == "Output">
                        boolean ${slot.name}${slot.type}${slot.io} = serialize.getBoolean(recipe, "${slot.name}", false, false);
                    </#if>
                <#elseif slot.type == "Number">
                    <#if slot.io == "Input">
                        <#if slot.optional>
                            double ${slot.name}${slot.type}${slot.io} = serialize.getDouble(recipe, "${slot.name}", true, ${slot.defaultDouble}d);
                        <#else>
                            double ${slot.name}${slot.type}${slot.io} = serialize.getDouble(recipe, "${slot.name}", false, 0d);
                        </#if>
                    <#elseif slot.io == "Output">
                        double ${slot.name}${slot.type}${slot.io} = serialize.getDouble(recipe, "${slot.name}", false, 0d);
                    </#if>
                <#elseif slot.type == "Text">
                    <#if slot.io == "Input">
                        <#if slot.optional>
                            String ${slot.name}${slot.type}${slot.io} = serialize.getString(recipe, "${slot.name}", true, "${slot.defaultString}");
                        <#else>
                            String ${slot.name}${slot.type}${slot.io} = serialize.getString(recipe, "${slot.name}", false, "");
                        </#if>
                    <#elseif slot.io == "Output">
                        String ${slot.name}${slot.type}${slot.io} = serialize.getString(recipe, "${slot.name}", false, "");
                    </#if>
                </#if>
            </#list>

            return new ${name}Recipe(res, ${pureIO?join(", ")});
        }

        @Override
        public @Nullable ${name}Recipe fromNetwork(ResourceLocation res, FriendlyByteBuf buf) {

            <#list data.slotList as slot>
                <#if slot.type == "Item">
                    <#if slot.io == "Input">
                        SizedIngredient ${slot.name}${slot.type}${slot.io} = SizedIngredient.fromNetwork(buf);
                    <#elseif slot.io == "Output">
                        ItemStack ${slot.name}${slot.type}${slot.io} = ItemStack.EMPTY;
                    </#if>
                <#elseif slot.type == "Fluid">
                    FluidStack ${slot.name}${slot.type}${slot.io} = FluidStack.EMPTY;
                <#elseif slot.type == "Logic">
                    boolean ${slot.name}${slot.type}${slot.io} = buf.readBoolean();
                <#elseif slot.type == "Number">
                    double ${slot.name}${slot.type}${slot.io} = buf.readDouble();
                <#elseif slot.type == "Text">
                    String ${slot.name}${slot.type}${slot.io} = buf.readUtf();
                </#if>
            </#list>
            if(buf instanceof JEIUtils.JEIByteBuffer buffer) {
                <#list data.slotList as slot>
                    <#if slot.type == "Item" && slot.io == "Output">
                        ${slot.name}${slot.type}${slot.io} = buffer.readItemStack();
                    <#elseif slot.type == "Fluid">
                        ${slot.name}${slot.type}${slot.io} = buffer.readFluidStack();
                    </#if>
                </#list>
            }
            return new ${name}Recipe(res, ${pureIO?join(", ")});
        }

        @Override
        public void toNetwork(FriendlyByteBuf buf, ${name}Recipe recipe) {
            if(buf instanceof JEIUtils.JEIByteBuffer buffer) {
                <#list data.slotList as slot>
                    <#if slot.type == "Item">
                        <#if slot.io == "Input">
                            recipe.${slot.name}${slot.type}${slot.io}().toNetwork(buf);
                        <#elseif slot.io == "Output">
                            buffer.writeItemStack(recipe.${slot.name}${slot.type}${slot.io}());
                        </#if>
                    <#elseif slot.type == "Fluid">
                        buffer.writeFluidStack(recipe.${slot.name}${slot.type}${slot.io}());
                    <#elseif slot.type == "Logic">
                        buf.writeBoolean(recipe.${slot.name}${slot.type}${slot.io}());
                    <#elseif slot.type == "Number">
                        buf.writeDouble(recipe.${slot.name}${slot.type}${slot.io}());
                    <#elseif slot.type == "Text">
                        buf.writeUtf(recipe.${slot.name}${slot.type}${slot.io}());
                    </#if>
                </#list>
            }
        }
    }

    // Unused
    @Override
    public @Nonnull NonNullList<Ingredient> getIngredients() {
        return NonNullList.withSize(1, Ingredient.EMPTY);
    }

    // Unused
    @Override
    public boolean matches(@NotNull SimpleContainer pContainer, Level pLevel) {
        return false;
    }

    // Unused
    @Override
    public boolean canCraftInDimensions(int pWidth, int pHeight) {
        return true;
    }

    // Unused
    @Override
    public @NotNull ItemStack getResultItem(RegistryAccess access) {
        return ItemStack.EMPTY;
    }

    // Unused
    @Override
    public ItemStack assemble(@NotNull SimpleContainer pContainer, RegistryAccess access) {
        return ItemStack.EMPTY;
    }
}</#compress>
