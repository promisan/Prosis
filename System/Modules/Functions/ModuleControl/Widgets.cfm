
<!--- this update the centrally supported notifiers, productivity widgets in the backoffice menu --->

<!--- -------- --->
<!--- Notifier --->
<!--- -------- --->

<cf_insertwidgets 
	SystemModule="Portal"
	FunctionClass="Portal"
	FunctionName="HelpWizard"
	MenuClass="Notifier"
	Operational="1">
	
<!--- ------- --->	
<!--- widgets --->
<!--- ------- --->	
	
<cf_insertwidgets 
	SystemModule="Portal"
	FunctionClass="Portal"
	FunctionName="NotePad"
	MenuClass="Widget"
	MenuOrder="1"
	FunctionMemo="Quick Notes"
	FunctionDirectory="Widgets/NotePad"
	FunctionPath="Notepad.cfm"
	EnforceUpdate="1"
	Operational="1">
	