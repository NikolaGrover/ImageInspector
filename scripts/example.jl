using Revise
using ImageInspector,MLDatasets, Plots

x = FashionMNIST.traintensor(1);


plot(
    plot(image(x; flip = true); title = "flip = true"),
    plot(image(x; flip = false); title = "flip = false");
    axis = nothing,
    border = :none,
)

x1 = FashionMNIST.traintensor(1);
x2 = CIFAR10.traintensor(2);
plot(
    plot(image(x1)),
    plot(image(x2));
    axis = nothing,
    border = :none
)

x = FashionMNIST.traintensor(1:10);
plot(plot.(image(x, [1,2]))...; axis = nothing, border = :none)

x = FashionMNIST.traintensor(1:10);
plot(imagegrid(x, 1:10; nrows = 2, sep = 2); axis = nothing, border = :none)