# BlockmanLORD, a big project and a big remake

## Copyright © 2025 [SpargatGroup](https://github.com/SpargatGroup). All rights reserved of the project [BlockmanLORD](https://github.com/SpargatGroup/BlockmanLORD)

## Help us

- Make pull requets to add fixes or new functions
- Report bugs
- Make suggestions
- Donate money(if wanted)

## Contribuitors

[![Donate](https://img.shields.io/badge/Support-Patreon-orange.svg)](https://patreon.com/Spargat)

[![Forkers repo roster for @SpargatGroup/BlockmanLORD](https://reporoster.com/forks/SpargatGroup/BlockmanLORD)](https://github.com/SpargatGroup/BlockmanLORD/network/members)

[![Stargazers repo roster for @SpargatGroup/BlockmanLORD](https://reporoster.com/stars/SpargatGroup/BlockmanLORD)](https://github.com/SpargatGroup/BlockmanLORD/stargazers)

## Build status

[![CMake build status](https://github.com/SpargatGroup/BlockmanLORD/actions/workflows/cmake-build.yml/badge.svg)](https://github.com/SpargatGroup/BlockmanLORD/actions)

[![Web build status](https://github.com/SpargatGroup/BlockmanLORD/actions/workflows/web-deploy.yml/badge.svg)](https://github.com/SpargatGroup/BlockmanLORD/actions)

## Open source and how it helps: 

- It helps us having support from other developers 
- It helps other learn and get ideas for making they own one 
- It helps others to make own version of BlockmanLORD

## Differences betwen BlockmanLORD and Blockman GO

<table>
    <thead>
        <tr>
            <th>Differences</th>
            <th>Blockman GO</th>
            <th>BlockmanLORD</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>3d apis</td>
            <td>OpenGL, OpenGL ES, Vulkan, DirectX, Metal</td>
            <td>OpenGL, OpenGL ES, Vulkan, DirectX, Metal</td>
        </tr>
        <tr>
            <td>3d models</td>
            <td>.mesh .actor .effect .anim .skel .mca</td>
            <td>.obj .fbx .mesh.xml .mca .gltf .glb and more...</td>
        </tr>
        <tr>
            <td>Made-in</td>
            <td>CMake/Unity</td>
            <td>CMake</td>
        </tr>
        <tr>
            <td>Country-made</td>
            <td>China</td>
            <td>Romanian</td>
        </tr>
        <tr>
            <td>Owner</td>
            <td>SandBoxOl Network/Gverse</td>
            <td>SpargatGroup</td>
        </tr>
    </tbody>
</table>

## Build BlockmanLORD 

### For build you will need Vulkan or DirectX 11, CMake 3.30 and C++23

```bash
cmake -DBLORD_MODEL=vk . # or d3d if you use directx
cmake --build . # or make -k
```