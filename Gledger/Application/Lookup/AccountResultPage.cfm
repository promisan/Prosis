
<cfparam name="url.row" default="100">

<cfset rows    = url.row>
<cfset first   = ((URL.Page-1)*rows)+1>
<cfset pages   = Ceiling(url.records/rows)>
<cfif pages lt '1'>
   <cfset pages = '1'>
</cfif>

<cfif pages gte "2">

<select name="page" id="page" size="1" style="border:0px" class="regularxl" onChange="reloadForm()">
    <cfloop index="Item" from="1" to="#pages#" step="1">
        <cfoutput><option value="#Item#"<cfif URL.page eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
   	</cfloop>	 
</SELECT>   

<cfelse>

<input type="hidden" name="page" value="1" id="page">

</cfif>