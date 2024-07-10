# Roku Component Library

🚧 This project is under construction, use at your own risk!

A collection of components that can be used as building blocks for developing applications on the Roku platform.

## Getting Started

To evaluate the components within this repository you'll need to have the VSCode IDE and the `BrightScript Language` extension installed as BrighterScript is used for the build process (via `launch.json`).

The idea is that the components such as `ChannelPerformanceComponent` are contained within their own folders, and carried across into the `App` folder during the build process for testing. You could opt to follow this approach when using the components within your project or you could simply take the files and add them under the `/components` folder.

Within each component folder you can expect to find several files, these being:

- A README.md file explaining the purpose and functionality of the component (as well as the version).
- A /components folder containing:
  - The component itself, situated within a suitably named folder.
  - Tests for the component where applicable.

To test the components in a dummy app you can simply trigger the "Run & Debug" functionality from within VSCode to see the component in action. To debug further, you can place breakpoints within the component files to see how they function.

## Contributing

Pull requests are welcome. For any major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests where appropriate.

## License

MIT - See the adjacent LICENSE file for details.
