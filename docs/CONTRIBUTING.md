# Contributing Guide

Thank you for your interest in contributing to Flutter iOS Setup!

## How to Contribute

### Reporting Issues

Found a bug or have a feature request? Please create an issue with:

- **macOS version** and architecture (Intel/Apple Silicon)
- **Error message** (full output)
- **Steps to reproduce**
- **Expected vs actual behavior**
- **Log files** (from `logs/` directory)

### Suggesting Improvements

We welcome suggestions for:
- Better error messages
- Additional checks and validations
- Documentation improvements
- New features

### Code Contributions

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Test thoroughly** on a clean macOS installation if possible
5. **Commit with clear messages**:
   ```bash
   git commit -m "feat: add XYZ feature"
   ```
6. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create a Pull Request**

## Development Guidelines

### Code Style

- Use bash best practices (shellcheck compliant)
- Follow existing code structure
- Add comments for complex logic
- Use meaningful variable names

### Testing

Test your changes on:
- **Both Intel and Apple Silicon Macs** (if possible)
- **Clean installation** (no existing Flutter/Xcode)
- **Existing installation** (ensure resume capability works)

### Documentation

- Update relevant docs in `docs/` directory
- Add troubleshooting entries for new issues
- Update README if adding features

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation only
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance tasks

Examples:
```
feat: add support for Android setup
fix: resolve CocoaPods installation on Apple Silicon
docs: improve device connection guide
refactor: modularize installation functions
```

## Project Structure

```
flutter-ios-setup/
├── setup.sh              # Main script
├── config/
│   └── config.example.sh # Configuration template
├── scripts/
│   ├── verify.sh         # Verification script
│   └── lib/              # Shared libraries
│       ├── logger.sh     # Logging functions
│       ├── utils.sh      # Utility functions
│       └── checks.sh     # System checks
├── docs/                 # Documentation
│   ├── DEVICE-CONNECTION.md
│   ├── APPLE-DEVELOPER.md
│   ├── TROUBLESHOOTING.md
│   └── CONTRIBUTING.md
├── logs/                 # Installation logs (git ignored)
└── state/                # State files (git ignored)
```

## Adding New Features

### Adding a New Installation Step

1. Add function to `setup.sh`:
   ```bash
   install_new_tool() {
       local step_name="new_tool"

       if is_step_completed "$step_name"; then
           log_info "Skipping: New Tool (already installed)"
           return 0
       fi

       log_step X $TOTAL_STEPS "Installing New Tool"

       # Installation logic here

       mark_step_completed "$step_name"
   }
   ```

2. Call it in `main()` function
3. Update `TOTAL_STEPS` constant
4. Add check function to `scripts/lib/checks.sh`
5. Update documentation

### Adding a New Configuration Option

1. Add to `config/config.example.sh`
2. Document the option with comments
3. Use in relevant installation functions
4. Update README if user-facing

### Adding a New Utility Function

Add to appropriate library:
- **Logging**: `scripts/lib/logger.sh`
- **System checks**: `scripts/lib/checks.sh`
- **Utilities**: `scripts/lib/utils.sh`

## Pull Request Process

1. **Description**: Clearly describe what your PR does
2. **Testing**: Confirm you've tested the changes
3. **Documentation**: Update docs if needed
4. **Review**: Be responsive to feedback
5. **Merge**: Maintainers will merge when approved

## Questions?

- Open an issue with the `question` label
- Discuss in pull requests
- Check existing issues/PRs first

## Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Help others learn and grow
- Focus on what's best for the project

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
