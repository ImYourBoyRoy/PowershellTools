# SeleniumTools - Update-WebDrivers Module

## 📖 Overview

The `Update-WebDrivers.psm1` module automates the process of downloading and updating Selenium WebDrivers for Chrome, Firefox, and Edge browsers. This tool is essential for maintaining up-to-date WebDriver executables, ensuring compatibility with the latest browser versions in your Selenium automation projects.

## 🚀 Features

- Automatically checks for the latest WebDriver versions
- Downloads and updates WebDrivers for Chrome, Firefox, and Edge
- Generates SHA256 hash files for downloaded executables
- Supports updating individual browsers or all at once
- Verbose logging for detailed update process information

## 📋 Requirements

- PowerShell 5.1 or later
- Microsoft.PowerShell.Archive module (version 1.0.0.0 or later)

## 🛠️ Installation

1. Clone this repository or download the `Update-WebDrivers.psm1` file.
2. Place the file in your desired module directory or in the SeleniumTools folder of your project.

## 🔧 Usage

1. Import the module:
   ```powershell
   Import-Module .\Update-WebDrivers.psm1
   ```

2. Update WebDrivers for a specific browser:
   ```powershell
   Update-WebDrivers -Browser Chrome -Verbose
   ```

3. Update WebDrivers for all supported browsers:
   ```powershell
   Update-WebDrivers -Browser All -Verbose
   ```

### Parameters

- `-Browser`: Specifies which browser's WebDriver to update. Valid options are 'Chrome', 'Firefox', 'Edge', or 'All'.
- `-AssembliesPath`: (Optional) Specifies the path where WebDriver executables will be saved. By default, it uses the 'assemblies' folder in the Selenium module directory.

## 📝 Examples

Update Chrome WebDriver:
```powershell
Update-WebDrivers -Browser Chrome -Verbose
```

Update all WebDrivers:
```powershell
Update-WebDrivers -Browser All -Verbose
```

Update Firefox WebDriver to a custom path:
```powershell
Update-WebDrivers -Browser Firefox -AssembliesPath "C:\WebDrivers" -Verbose
```

## 🤝 Contributing

Contributions to improve Update-WebDrivers are welcome. Please feel free to submit pull requests or create issues for bugs and feature requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 📬 Contact

For any questions or support, please open an issue in the GitHub repository.

## 🙏 Acknowledgments

- Selenium Project for providing WebDriver interfaces
- Browser vendors (Google, Mozilla, Microsoft) for maintaining WebDriver executables

Happy automating! 🚗💨
