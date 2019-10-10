# globalpayredeban-ios
El SDK globalpayredeban iOS es una biblioteca que permite a los desarrolladores conectarse fácilmente al API de GlobalPay Redeban de Tarjetas de Crédito


**

SDK GlobalPay Redeban para  iOS
-----------------

**


----------
### Requerimientos 

*Version <= 1.4.x*
- iOS 9.0 o Posterior
- Xcode 9

*Version >= 1.5.x*
- iOS 9.0 o Posterior 
- Xcode 10


**Dependencias del Sistema:**

Accelerate
AudioToolbox
AVFoundation
CoreGraphics
CoreMedia
CoreVideo
Foundation
MobileCoreServices
OpenGLES
QuartzCore
Security
UIKit
CommonCrypto (Sólo para la versión 1.4)


**Configuración del proyecto**
- ObjC in other linker flags in target
- lc++ in target other linker flags
- Deshabilite Bitcode


----------
# Instalación

**Carthage**

Si usted no ha instalado la última versión de [Carthage](https://github.com/Carthage/Carthage)

If you haven't already, install the latest version of [Carthage](https://github.com/Carthage/Carthage)

Añada esto al Cartfile:

``` git "https://github.com/globalpayredeban/globalpayredeban-ios.git" ```

Para version Beta:

``` git "https://github.com/globalpayredeban/globalpayredeban-ios.git" "master" ```


**Configuración ObjC**

Configure ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES

En Build Phases -> Embed Frameworks Quite la selección "Copy Only When Installing"


# **Instalación Manual (Recomendado)**

El SDK GlobalPay Redeban es una biblioteca dinámica ([Más información](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/OverviewOfDynamicLibraries.html)) por lo tanto usted tendrá que construir cada versión para el objetivo deseado (simulador y dispositivo). Para realizar la integración de manera fácil, puede seguir las siguientes instrucciones para obtener un archivo .framework universal.


1. Construya el SDK y genere los archivos .framework

- Si quiere construir usted mismo el SDK o está utilizando una nueva versión o versión beta de Xcode. Descargue el proyecto de github y corra el siguiente script dentro de de su archivo raíz (root)


```
sh package.sh

```

Esto creará un directorio /build donde estarán todoso los .framework necesarios (simulador, iphoneos y universal) 

- O si lo prefiere puede descargar los archivos .framework pre compilados de [Releases](https://github.com/globalpayredeban/globalpayredeban-ios/releases)

2. Arrastre el GlobalPayRedebanSDK.framework (de preferencia una versión universal) a su proyecto y seleccione "Copy Files if needed".

En Target->General : Añada GlobalPayRedebanSDK.framework a _Embeeded Libraries and Linked Frameworks and  Libraries_


![Example](https://s3.amazonaws.com/cdn.paymentez.com/apps/ios/tutorial2.gif)


3. Actualice los  _Build Settings_ con: 

Configure ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES

En Build Phases -> Embed Frameworks Quite la selección "Copy Only When Installing"

![Example](https://s3.amazonaws.com/cdn.paymentez.com/apps/ios/tutorial3.gif)

4. Si usted utiliza la versión Universal y quiere subir la aplicación a la appstore. Añada la fase de correr el script: Target->Build Phases -> + ->New Run Script Phase. Y pegue lo siguiente. Asegúrese de añadir esta _build phase_ después de la fase _Embed Fraameworks_.
```
bash "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}/PaymentezSDK.framework/install_dynamic.sh"
```

![Example](https://s3.amazonaws.com/cdn.paymentez.com/apps/ios/tutorial4.gif)

## **Uso**

Importantdo Swift

import GlobalPayRedebanSDK

Configure su aplicación dentro de AppDelegate->didFinishLaunchingWithOptions. Debe de utilizar las credenciales tipo Cliente de GlobalPayRedeban (Solo ADD habilitado).


GlobalPayRedebanSDKClient.setEnvironment("AbiColApp", secretKey: "2PmoFfjZJzjKTnuSYCFySMfHlOIBz7", testMode: true)


# Tipos de implementación

Hay tres maneras de presenar el formulario para añadir una tarjeta (Add Card):

1. Como un Widget en una Custom View
2. Como un Viewcontroller  Empujado en tu UINavigationController 
3. Como un Viewcontroller presentado en un Modal

El formulario de AddCard incluye: Scan io de la tarjeta, validaciones de la tarjeta.



## Mostrar el Widget de AddCard 

Para crear el widget debe generar el PaymentezAddNativeController del  PaymentezSDKClient. Luego añadalo al UIView que será el contenedor del formulario de GlobalPayRedeban. La altura mínima deberá de ser 300 px, y la pantall completa de ancho (270px sin el logo de GlobalPayRedeban)

**Nota:** _Cuando utilice el formulario de GlobalPayRedeban como Widget, el ViewController personalizado del Cliente será responsable del layout y la sincronización (también conocido como Spinner o Loading)_

El widget puede scanear con la cámara del celular, la información de la tarjeta, utilizando card.io.

![Example](https://developers.globalpay.com.co/wp-content/uploads/2017/10/ios-example.png)

### Swift

```swift
let paymentezAddVC = self.addPaymentezWidget(toView: self.addView, delegate: nil, uid:UserModel.uid, email:UserModel.email)

```

### Objc

```objc


[self addPaymentezWidgetToView:self. addView delegate:self uid:@"myuid" email:@"myemail"];

```


Recupere la tarjeta de crédito válida de PaymentezAddNativeController (Widget):


### Swift
```swift
if let validCard = paymentezAddVC.getValidCard() // CHECK IF THE CARD IS VALID, IF THERE IS A VALIDATION ERROR NIL VALUE WILL BE RETURNED
{
sender?.isEnabled = false
PaymentezSDKClient.createToken(validCard, uid: UserModel.uid, email: UserModel.email, callback: { (error, cardAdded) in

if cardAdded != nil // handle the card status
{
}
else if error != nil //handle the error
{
}
})
}
```

### Objc
```objc
PaymentezCard *validCard = [self.paymentezAddVC getValidCard];
if (validCard != nil) // Check if it is avalid card
{

[PaymentezSDKClient add:validCard uid:USERMODEL_UID email:USERMODEL_EMAIL callback:^(PaymentezSDKError *error, PaymentezCard *cardAdded) {
[sender setEnabled:YES];
if(cardAdded != nil) // handle the card status
{

}
else  //handle the error
{

}
}];
}
```
## Empujado a su NavigationController

### Swift
```swift
self.navigationController?.pushPaymentezViewController(delegate: self, uid: UserModel.uid, email: UserModel.email)

```

### Objc

```objc


[self.navigationController pushPaymentezViewControllerWithDelegate:self uid:@"myuid" email:@"mymail@mail.com"]`;
```

## Presentado como Modal

### Swift
```swift
self.presentPaymentezViewController(delegate: self, uid: "myuid", email: "myemail@email.com")

```

### Objc

```objc

[self presentPaymentezViewControllerWithDelegate:self uid:@"myuid" email:@"myemail@email.com"];
```


##  Protocolo PaymentezCardAddedDelegate


Si presenta el formulario como un controlador de vista (push y modal), debe implementar el protocolo PaymetnezCardAddedDelegate para manejar los estados o acciones dentro del controlador de vista. Si está utilizando la implementación de Widget, puede manejar las acciones como se describe anteriormente.


```swift
protocol PaymentezCardAddedDelegate
{
func cardAdded(_ error:PaymentezSDKError?, _ cardAdded:PaymentezCard?)
func viewClosed()
}
```
`func cardAdded(_ error:PaymentezSDKError?, _ cardAdded:PaymentezCard?)` se llama cada vez que hay un error o se agrega una tarjeta.

`func viewClosed()`  Cuando el modal está cerrado. 

## Escaneo de la Tarjeta


Si desea escanear usted mismo, use card.io

### Swift
```swift
PaymentezSDKClient.scanCard(self) { (closed, number, expiry, cvv, card) in
if !closed // user did not closed the scan card dialog
{
if card != nil  // paymentezcard object to handle the data
{

}
})
```

### ObjC
```objc
[PaymentezSDKClient scanCard:self callback:^(BOOL userClosed, NSString *cardNumber, NSString *expiryDate, NSString *cvv, PaymentezCard *card) {

if (!userClosed) //user did not close the scan card dialog
{
if (card != nil) // Handle card
{

}

}
}];
```

## Añadir una tarjeta (Sólo integraciones PCI) 

Para integraciones de formulario personalizado

Campos requeridos:
+ cardNumber: Número de tarjeta como cadena sin ningún separador, por ejemplo: 4111111111111111.
+ cardHolder: Nombre del tarjetahabiente.
+ expiryMonth: Entero que representa la el mes de expiración de la tarjeta, 01-12.
+ expiryYear: Entero que representa el año de expiración de la tarjeta, por ejemplo 2020.
+ cvc: Código de seguridad de la tarjeta como cadena, por ejemplo '123'.

### Swift
```swift
let card = PaymentezCard.createCard(cardHolder:"Gustavo Sotelo", cardNumber:"4111111111111111", expiryMonth:10, expiryYear:2020, cvc:"123")

if card != nil  // A valid card was created
{
PaymentezSDKClient.add(card, uid: "69123", email: "gsotelo@paymentez.com", callback: { (error, cardAdded) in

if cardAdded != nil
{
//the request was succesfully sent, you should check the cardAdded status
}

})
}
else
{
//handle invalid card
}
```

### ObjC

```objc
PaymentezCard *validCard = [PaymentezCard createCardWithCardHolder:@"Gustavo Sotelo" cardNumber:@"4111111111111111" expiryMonth:10 expiryYear:2020 cvc:@"123"];
if (validCard != nil) // Check if it is avalid card
{

[PaymentezSDKClient add:validCard uid:USERMODEL_UID email:USERMODEL_EMAIL callback:^(PaymentezSDKError *error, PaymentezCard *cardAdded) {
[sender setEnabled:YES];
if(cardAdded != nil) // handle the card status
{

}
else  //handle the error
{

}
}];
}

```


## Obtener el SessionId

Los cobros deben de ser implementados en su backend. Por motivos de seguridad, nosotros proveemos un generador seguro de session id, dato que es utilizado por nuestro sistema de antifraude. Este recoge la información del dispositivo en segundo plano.

### Swift
```swift
let sessionId = PaymentezSDKClient.getSecureSessionId()
```
### Objc

```objc
NSString *sessionId = [PaymentezSDKClient getSecureSessionId];
```

## Herramientas

Obtener activos de la tarjeta


```swift
let card = PaymentezCard.createCard(cardHolder:"Gustavo Sotelo", cardNumber:"4111111111111111", expiryMonth:10, expiryYear:2020, cvc:"123")
if card != nil  // A valid card was created
{
let image = card.getCardTypeAsset()

}
```

Obtener el tipo de tarjeta (Solo Amex, Mastercard, Visa, Diners)

```swift
let card = PaymentezCard.createCard(cardHolder:"Gustavo Sotelo", cardNumber:"4111111111111111", expiryMonth:10, expiryYear:2020, cvc:"123")
if card != nil  // A valid card was created
{
switch(card.cardType)
{
case .amex:
case .masterCard:
case .visa:
case .diners:
default:
//not supported action
}

}
```

## Personalizar el Look & Feel

Usted puede personalizar los colores del widget

```swift
paymentezAddVC.baseFontColor = .white
paymentezAddVC.baseColor = .green
paymentezAddVC.backgroundColor = .white
paymentezAddVC.showLogo = false
paymentezAddVC.baseFont = UIFont(name: "Your Font", size: 12) ?? UIFont.systemFont(ofSize: 12)

```

Los elementos personalizables del formulario son los siguientes:

- `baseFontColor` : El color de la fuenta de los campos
- `baseColor`:  Color de las líneas y títulos de los campos
- `backgroundColor`: Color de fondo del widget 
- `showLogo`: Habilitar o deshabilitar el logo de GlobalPayRedeban 
- `baseFont`: Fuente de todo el formulario
- `nameTitle`: Cadena con el placeholder personalizado para el campo de Nombre
- `cardTitle`: Cadena con el placeholder personalizado para el campo de Tarjeta
- `invalidCardTitle`: Cadena para el mensaje de error cuando el número de tarjeta es inválido


## Construcción y Ejecución del PaymentezSwift
Antes de poder ejecutar la aplicación PaymentezStore, debe de configurarle su APP_CODE y APP_SECRET_KET y un backend de prueba.

1. Si aún no cuenta con credenciales, pídalas a su contancto en el equipo de GlobalPay Redeban.
2. Reemplace el `APP_CODE` and `APP_SECRET_KEY` en su AppDelegate como se muestra en la sección de Uso.
3. Dirígase a https://github.com/globalpayredeban/example-java-backend y haga click en "Deploy to Heroku" (es posible que tengas que registrarte para obtener una cuenta de Heroku como parte de este proceso). Proporcione sus credenciales de servidor de GlobalPayRedeban `SERVER_APP_CODE` y` SERVER_APP_KEY` en los campos "Env". Haga click en "Deloy for Free".
4. Reemplace la variable `BACKEND_URL` en el MyBackendLib.swift (dentro de la variable myBackendUrl) 
 con la URL de la aplicación que Heroku le proporciona (por ejemplo," https://my-example-app.herokuapp.com ")
5. Reemplace las variables (uid y email) en UserModel.swift con su id de usuario de prueba.

Nota importante: si solo tiene un APP_CODE, suponga que es su `SERVER_APP_CODE`. Por lo tanto, debe solicitar a su contacto en el equipo de GlobalPay Redeban su `CLIENT_APP_CODE`.
