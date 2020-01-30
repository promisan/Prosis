<cfparam name="Attributes.DecimalHour">

<cfset vHours = "">
<cfset vMinutes = "">

<cfset vHours = Int(Abs(Attributes.DecimalHour))>
<cfif len(vHours) eq 1>
	<cfset vHours = "0" & vHours>
</cfif>

<cfset vMinutes = Round(60*(Abs(Attributes.DecimalHour) - Int(Abs(attributes.DecimalHour))))>
<cfif len(vMinutes) eq 1>
	<cfset vMinutes = "0" & vMinutes>
</cfif>

<cfset caller.StringHour = vHours & ":" & vMinutes>