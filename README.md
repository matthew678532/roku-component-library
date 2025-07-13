# Roku Component Library

A collection of components that can be used as building blocks for developing applications on the Roku platform.

## Getting Started

To evaluate the components within this repository you'll need to have the VSCode IDE and the `BrightScript Language` extension installed as BrighterScript is used for the build process (via `launch.json`).

The idea is that components such as the `ChannelPerformanceComponent` are contained within their own folders, and carried across into the `App` folder during the build process for testing. You could opt to follow this approach when using the components within your project or you could simply copy the files into the `/components` folder.

Within each component folder you can expect to find several files, these being:

- A `README.md` file explaining the purpose and functionality of the component
  - Also tracks the version of the component.
- A `/components` folder containing:
  - The component itself, situated within a suitably named folder (e.g. `ChannelPerformanceComponent`).
  - Tests for the component where applicable, situated with a `/tests` folder.

To test the components in a dummy app you can simply trigger the "Run & Debug" launch command from within VSCode to see the component in action. To debug further, you can place breakpoints within the component files to see how they function.

You could also trigger the "Test" launch command to see how the component is being tested for further understanding.

## Contributing

Pull requests are welcome. For any major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests where appropriate.

## License

MIT - See the adjacent LICENSE file for details.
