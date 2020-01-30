//Language

//Default English "en"
var languageDatePickerLanguage		= "en"; //es, en

var languageTxtLanguage 			= "Language";
var languageTxtEnglish 				= "English";
var	languageTxtSpanish	 			= "Spanish";

var languageTxtAnimations 			= "Animations";
var languageTxtEnable 				= "Enabled";
var	languageTxtDisable 				= "Disabled";

var languageTxtMenuBuilding 		= "Building";
var languageTxtMenuDate 			= "Date";
var languageTxtMenuRefresh 			= "Refresh";
var languageTxtMenuAbout 			= "About";

var languageTxtFilter1 				= "Class";
var languageTxtFilter2 				= "Area";
var languageTxtFilter3 				= "Hour";
var languageTxtFilter4 				= "Options";
var languageTxtSearch 				= "Search";
var languageTxtCompleted			= "Completed";
var languageTxtNotCompleted			= "Not Completed";
var languageTxtAskCompletion  		= "Complete this action?";
var languageTxtWithPictures			= "With pictures";
var languageTxtWithoutPictures		= "Without pictures";
var languageTxtType					= "Type";

var languageTxtCleanSearch			= "Clear search";
var languageTxtLoadData				= "Load Data";
var languageTxtAboutIcons 			= "Icons by";
var languageTxtLoading				= "Loading data...";
var languageTxtLoadingConfig		= "Getting app configuration...";
var languageTxtCompletingAction 	= "Completing action...";
var languageTxtCloseTitle 			= "Close";
var languageTxtAddDetails 			= "Add Details";
var languageTxtShowAll				= "Show All";
var languageTxtSaveChanges			= "Save Changes";

var	languageTxtPersonID				= "ID";
var	languageTxtPersonName			= "Name";
var	languageTxtPersonGender			= "Sex";
var languageTxtPersonGenderM		= "Male";
var	languageTxtPersonGenderF		= "Female";
var	languageTxtPersonSchedule		= "Schedule";

var languageTxtUpload				= "Upload";
var languageTxtCamera				= "Camera";
var languageTxtGallery				= "Gallery";

var languageTxtLogin				= "Login";
var languageTxtLogout				= "Logout";
var languageTxtUserName				= "User";
var languageTxtPassword				= "Password";
var languageTxtLoginWait			= "Logging in...";
var languageTxtLoginFields			= "Please, type your user and password.";
var languageTxtLogoutWait			= "Logging out...";
var languageTxtSessionWait			= "Validating session...";
var languageTxtErrorLogin			= "The provided credentials are not valid!";
var languageTxtErrorLogout			= "Error trying to logout, please try again.";
var languageTxtErrorInternet		= "No Internet connection.  Operation not allowed.";
var languageTxtErrorUpload			= "Error trying to upload. Prosis error code: Mobile";
var languageTxtErrorText			= "Prosis error code: Mobile";
var languageTxtRemovePicture		= "Do you want to remove this picture?";
var languageTxtRemovingPicture 		= "Removing picture...";
var languageTxtUpdatingMemo			= "Updating memo...";
var languageTxtTryAgain				= "Please, try again.";
var languageTxtUploadedBy			= "Uploaded by";
var languageTxtErrorExpiredLicense 	= "Expired license.  Please contact your administrator.";
var languageTxtEvents				= "Events";
var languageTxtPersonAssignment 	= "Assignment";
var languageTxtTodayActivities  	= "Activities to supervise for this day";
var languageTxtTodayEmployees   	= "Employees for this day";
var languageTxtNoTodayActivities 	= "No activities to supervise for this day";

var languageTxtToday				= "Today";
var languageTxtYesterday			= "Yesterday";
var languageTxtTomorrow				= "Tomorrow";


//Change the language given the code
function changeLanguageText(langCode) {

	//English "en"
	if (langCode == "en") {
	
		languageDatePickerLanguage	= "en"; //es, en

		languageTxtLanguage 			= "Language";
		languageTxtEnglish 				= "English";
		languageTxtSpanish	 			= "Spanish";
		
		languageTxtAnimations 			= "Animations";
		languageTxtEnable 				= "Enabled";
		languageTxtDisable 				= "Disabled";
		
		languageTxtMenuBuilding 		= "Building";
		languageTxtMenuDate 			= "Date";
		languageTxtMenuRefresh 			= "Refresh";
		languageTxtMenuAbout 			= "About";
		
		languageTxtFilter1 				= "Class";
		languageTxtFilter2 				= "Area";
		languageTxtFilter3 				= "Hour";
		languageTxtFilter4 				= "Options";
		languageTxtSearch 				= "Search";
		languageTxtCompleted			= "Completed";
		languageTxtNotCompleted			= "Not Completed";
		languageTxtAskCompletion  		= "Complete this action?";
		languageTxtWithPictures			= "With pictures";
		languageTxtWithoutPictures		= "Without pictures";
		languageTxtType					= "Type";
		
		languageTxtCleanSearch			= "Clear search";
		languageTxtLoadData				= "Load Data";
		languageTxtAboutIcons 			= "Icons by";
		languageTxtLoading				= "Loading data...";
		languageTxtLoadingConfig		= "Getting app configuration...";
		languageTxtCompletingAction 	= "Completing action...";
		languageTxtCloseTitle 			= "Close";
		languageTxtAddDetails 			= "Add Details";
		languageTxtShowAll				= "Show All";
		languageTxtSaveChanges			= "Save Changes";
		
		languageTxtPersonID				= "ID";
		languageTxtPersonName			= "Name";
		languageTxtPersonGender			= "Sex";
		languageTxtPersonGenderM		= "Male";
		languageTxtPersonGenderF		= "Female";
		languageTxtPersonSchedule		= "Schedule";
		
		languageTxtUpload				= "Upload";
		languageTxtCamera				= "Camera";
		languageTxtGallery				= "Gallery";
		
		languageTxtLogin				= "Login";
		languageTxtLogout				= "Logout";
		languageTxtUserName				= "User";
		languageTxtPassword				= "Password";
		languageTxtLoginWait			= "Logging in...";
		languageTxtLoginFields			= "Please, type your user and password.";
		languageTxtLogoutWait			= "Logging out...";
		languageTxtSessionWait			= "Validating session...";
		languageTxtErrorLogin			= "The provided credentials are not valid!";
		languageTxtErrorLogout			= "Error trying to logout, please try again.";
		languageTxtErrorInternet		= "No Internet connection.  Operation not allowed.";
		languageTxtErrorUpload			= "Error trying to upload. Prosis error code: Mobile";
		languageTxtErrorText			= "Prosis error code: Mobile";
		languageTxtRemovePicture		= "Do you want to remove this picture?";
		languageTxtRemovingPicture 		= "Removing picture...";
		languageTxtUpdatingMemo			= "Updating memo...";
		languageTxtTryAgain				= "Please, try again.";
		languageTxtUploadedBy			= "Uploaded by";
		languageTxtErrorExpiredLicense	= "Expired license.  Please contact your administrator.";
		languageTxtEvents				= "Events";
		languageTxtPersonAssignment 	= "Assignment";
		languageTxtTodayActivities  	= "Activities for this day";
		languageTxtTodayEmployees   	= "Employees for this day";
		languageTxtNoTodayActivities 	= "No activities to supervise for this day";
		
		languageTxtToday				= "Today";
		languageTxtYesterday			= "Yesterday";
		languageTxtTomorrow				= "Tomorrow";
		
	}
	
	//Espanol "es"
	if (langCode == "es") {
	
		languageDatePickerLanguage	= "es"; //es, en
		
		languageTxtLanguage 			= "Idioma";
		languageTxtEnglish 				= "Inglés";
		languageTxtSpanish	 			= "Español";
		
		languageTxtAnimations 			= "Animaciones";
		languageTxtEnable 				= "Habilitado";
		languageTxtDisable 				= "Desabilitado";
		
		languageTxtMenuBuilding 		= "Edificio";
		languageTxtMenuDate 			= "Fecha";
		languageTxtMenuRefresh 			= "Refrescar";
		languageTxtMenuAbout 			= "Info";
		
		languageTxtFilter1 				= "Clase";
		languageTxtFilter2 				= "Área";
		languageTxtFilter3 				= "Hora";
		languageTxtFilter4 				= "Opciones";
		languageTxtSearch 				= "Buscar";
		languageTxtCompleted			= "Completado";
		languageTxtNotCompleted			= "No Completado";
		languageTxtAskCompletion  		= "¿Completar esta acción?";
		languageTxtWithPictures			= "Con Fotografías";
		languageTxtWithoutPictures		= "Sin Fotografías";
		languageTxtType					= "Tipo";
		
		languageTxtCleanSearch			= "Limpiar Búsqueda";
		languageTxtLoadData				= "Cargar Datos";
		languageTxtAboutIcons 			= "Íconos por";
		languageTxtLoading				= "Cargando datos...";
		languageTxtLoadingConfig		= "Obteniendo configuración...";
		languageTxtCompletingAction 	= "Completando acción...";
		languageTxtCloseTitle 			= "Cerrar";
		languageTxtAddDetails 			= "Agregar Detalles";
		languageTxtShowAll				= "Todo";
		languageTxtSaveChanges			= "Guardar Cambios";
		
		languageTxtPersonID				= "ID";
		languageTxtPersonName			= "Nombre";
		languageTxtPersonGender			= "Sexo";
		languageTxtPersonGenderM		= "Masculino";
		languageTxtPersonGenderF		= "Femenino";
		languageTxtPersonSchedule		= "Horario";
		
		languageTxtUpload				= "Subir";
		languageTxtCamera				= "Cámara";
		languageTxtGallery				= "Galería";
			
		languageTxtLogin				= "Iniciar sesión";
		languageTxtLogout				= "Cerrar sesión";
		languageTxtUserName				= "Usuario";
		languageTxtPassword				= "Contraseña";
		languageTxtLoginWait			= "Iniciando sesión...";
		languageTxtLoginFields			= "Por favor, ingrese su usuario y contraseña.";
		languageTxtLogoutWait			= "Cerrando sesión...";
		languageTxtSessionWait			= "Validando sesión...";
		languageTxtErrorLogin			= "Las credenciales no son válidas!";
		languageTxtErrorLogout			= "Error tratando de cerrar sesión, por favor intente de nuevo.";
		languageTxtErrorInternet		= "Sin conexión a Internet.  Operación no permitida.";
		languageTxtErrorUpload			= "Error tratando de cargar el archivo. Código de Error Prosis: Mobile";
		languageTxtErrorText			= "Código de Error Prosis: Mobile";
		languageTxtRemovePicture		= "¿Desea remover esta fotografía?";
		languageTxtRemovingPicture 		= "Eliminando fotografía...";
		languageTxtUpdatingMemo			= "Actualizando memo...";
		languageTxtTryAgain				= "Por favor, intente de nuevo.";
		languageTxtUploadedBy			= "Subido por";
		languageTxtErrorExpiredLicense 	= "Licencia expirada.  Por favor contacte a su Administrador.";
		languageTxtEvents				= "Eventos";
		languageTxtPersonAssignment 	= "Puesto";
		languageTxtTodayActivities 		= "Actividades para supervisar en este día";
		languageTxtTodayEmployees   	= "Empleados de este día";
		languageTxtNoTodayActivities 	= "No hay actividades para supervisar en este día";
		
		languageTxtToday				= "Hoy";
		languageTxtYesterday			= "Ayer";
		languageTxtTomorrow				= "Mañana";
		
	}
	
}