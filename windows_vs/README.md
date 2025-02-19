# or run this on root project directory after installation of vs2019

## basic config

```bash
cmake -S .. -B ./windows_vs
```

## BlockmanLORD OpenGL

```bash
cmake -DBLORD_MODEL=gl -DBLORD_BUILD=BlockmanLORD -S .. -B ./windows_vs
```

## BlockmanLORD Vulkan

```bash
cmake -DBLORD_MODEL=vk -DBLORD_BUILD=BlockmanLORD -S .. -B ./windows_vs
```

## BlockmanLORD DirectX

```bash
cmake -DBLORD_MODEL=d3d -DBLORD_BUILD=BlockmanLORD -S .. -B ./windows_vs
```

## GameServer

```bash
cmake -DBLORD_BUILD=GameServer -S .. -B ./windows_vs
```

## Blockman Editor

```bash
cmake -DBLORD_BUILD=BlockmanEditor -S .. -B ./windows_vs
```