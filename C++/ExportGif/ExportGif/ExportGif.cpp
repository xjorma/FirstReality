// ExportGif.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
extern "C"
{
    #include "gifdec.h"
}
#include <iostream>

int main()
{
    gd_GIF* gif = gd_open_gif("./data/sword.gif");
    gd_get_frame(gif);

    //Hack Hack Hack
    gif->height = 35;

    std::cout << "const vec3 palette[" << gif->palette->size << "] = vec3[](";

    for (int i = 0; i < gif->palette->size; i++)
    {
        if (i % 8 == 0)
        {
            std::cout << "\n\t";
        }
        std::cout << "vec3(" << (int)(gif->palette->colors[i * 3 + 0]) << ", " << (int)(gif->palette->colors[i * 3 + 1]) << ", " << (int)(gif->palette->colors[i * 3 + 2]) << ")";
        if (i != gif->palette->size - 1)
            std::cout << ", ";
    }

    std::cout << "\n);";

    std::cout << "const uint image[" << gif->height * gif->width / 4 << "] = uint[](";

    for (int y = 0; y < gif->height; y++)
    {
        for (int x = 0; x < gif->width / 4; x++)
        {
            if (((y * gif->width / 4 + x)  % 16) == 0)
            {
                std::wcout << "\n\t";
            }
            std::cout << (((unsigned int)(gif->frame[y * gif->width + x * 4 + 0]) << 24) | ((unsigned int)(gif->frame[y * gif->width + x * 4 + 1]) << 16) | ((unsigned int)(gif->frame[y * gif->width + x * 4 + 2]) << 8) | ((unsigned int)(gif->frame[y * gif->width + x * 4 + 3]) << 0)) << "U";
            if (y * gif->width / 4 + x != gif->height * gif->width / 4 - 1)
                std::cout << ", ";
        }
    }
    std::cout << "\n);";

    gd_close_gif(gif);
}

