
<cfparam name="attributes.Warehouse"            default="">
<cfparam name="Attributes.TransactionDate"      default="#DateFormat(now(), CLIENT.DateFormatShow)#">
<cfparam name="Attributes.TransactionTime"      default="#TimeFormat(now(), 'HH:MM')#">

<!--- Instatiating time object object--->
<cfset oTimer = CreateObject("component","Service.Process.Materials.WarehouseTime")/>

<cfset s = oTimer.getTime(Attributes.TransactionDate, Attributes.TransactionTime, Attributes.Warehouse)>

<cfset caller.localtime    = s.localtime>
<cfset caller.timezone     = s.timezone>
<cfset caller.tzcorrection = s.tzcorrection>


	




