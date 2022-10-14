# Customer Customisation



## 1. Backend URL connection

The first thing to do is switch to customer's deployed GraphQL backend component. In order to do so open the following file

`redux/lib/graphql_client.dart`

Now in the file change the following line to customer's domain name:

```dart
class GraphQLClientAPI {
  static String gqlServerHost = 'trade.mobidax.io';
```



## 2. Color Scheme 

To change color scheme of the application open
`lib/utils/theme.dart`

In the file change the following fields to customer color schehe:

```dart
const Color primaryColor = Color(0xff003A4C);
const Color onPrimary = Colors.white;
const Color backgroundColor = Color(0xff002F41);
const Color primaryVariant = Color(0xff12A8A7);
const Color systemGreen = Colors.green;
const Color systemRed = Colors.red;
const Color accentColor = Color(0xff12A8A7);
```



## 3. Font Family

### 3.1. Add Font Family to assets

In the folder `assets/fonts` add standard font ttf files.

### 3.2. Add font to pubspec.yaml

Add the font to the following section in `pubspec.yaml`

```yaml
  fonts:
    - family: SourceSansPro
      fonts:
        - asset: assets/fonts/Source_Sans_Pro/SourceSansPro-Regular.ttf
        - asset: assets/fonts/Source_Sans_Pro/SourceSansPro-Italic.ttf
          style: italic
        - asset: assets/fonts/Source_Sans_Pro/SourceSansPro-Bold.ttf
          weight: 700
        - asset: assets/fonts/Source_Sans_Pro/SourceSansPro-SemiBold.ttf
          weight: 500
```

### 3.3. Add font to theme.dart file 

Open theme file `lib/utils/theme.dart ` and change the following line to your custom font

```dart
final String _fontFamily = 'SourceSansPro';
```

## 4. Localization

Localization files are stored in the folder `assets/lang/*`. In order to add another language, just take `assets/lang/en-US.json` file, translate it and add another file to `assets/lang` e.x. `assets/ua-UA.json`

### Change Mobidax -> Customer Name

In the existing localisation files change "mobidax" to customer project name, do this process to all existing localisation files.

```json
{
	"app_title": "MobiDAX",
	"bank_account": "BitDAX Ltd.",
	"terms_and_cond": "By signing up on BitDAX, you agree with the Terms & Conditions",
}
```



## 5. Logo and waves background

### Change all these files to customer assets

1. `assets/icons/logo.png` - full size logo used on onboarding screen
2. `assets/icons/small_logo.png` - small narrow logo used in side navigation
3. `assets/icons/waves.png` - background image used on all screens



## 6. Launcher Icons

In order to change launcher icons, replace two files under the directory `assets/launcher`

1. Android: `icon.png`
2. IOS: `ios.png`

Run the following command to generate launcher icons:

` flutter pub run flutter_launcher_icons:main `



## Web Specific

### Favicon 

In order to change favicon replace 2 files under `web` directory 

1. `web/favicon.icon` 16x16
2. `web/apple-touch-icon.png` 180x180

Also replace icons in the folder `web/icons/*`

1. `Icon-192.png` 192x192
2. `Icon-512.png` 512x512

### App Title 

In file `web/index.html `change the following line

```html
  <title>mobidax</title>
```

In file `web/manifest.json` change the following line

```
{
    "name": "mobidax",
    "short_name": "mobidax",
    "description": "A new Flutter project.",

}
```



### Preloader

To change preloader replace the svg in the following file `web/index.html`

```html
<div class="preloader">
    <svg></svg>
</div>
```

Also change color scheme to your desired one in the file `web/styles.css`

```css
body {
	background: #003A4C;  // Preloader screen background 
	overflow: hidden;
	display : flex;
	justify-content: center;
	align-items: center;
	height:100vh;
	width:100vw;
}

.preloader:before {
	--c: #12A8A7; // Preloader round color
	--cT: #ffffff;
	animation: spin 2s ease-in-out infinite var(--playState);
	background-image: radial-gradient(100% 100% at 48% 50%,var(--cT) 48%,currentColor 52%);
	border: 0;
	border-right: 0.3em solid;
	box-shadow: 0.3em 0 0.3em;
	color: var(--c);
	content: "";
	display: block;
	width: 100%;
	height: 100%;
	transform: translateX(-0.15em) rotate(0deg);
	transform-origin: calc(50% - 0.15em) 50%;
}

```



