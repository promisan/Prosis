
<cfparam name="Attributes.Name" default="">
<cfparam name="Attributes.Value" default="">

<cfoutput>

<select name="#Attributes.Name#" id="#Attributes.Name#">

	<option value="IndexNo" <cfif "IndexNo" eq "#Attributes.Value#">selected</cfif>>IndexNo</option>
	<option value="Grade" <cfif "Grade" eq "#Attributes.Value#">selected</cfif>>Grade</option>
	<option value="BirthDate" <cfif "BirthDate" eq "#Attributes.Value#">selected</cfif>>Date of Birth [DDMMYYYY]</option>
	<option value="Travel Request" <cfif "Travel Request" eq "#Attributes.Value#">selected</cfif>>Recent travel request No</option>
	
</select>	

</cfoutput>