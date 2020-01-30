<cfparam name="Attributes.TotalWidth"     default="100%">    
<cfparam name="Attributes.startcolor"     default="FFFFFF">  
<cfparam name="Attributes.endcolor"       default="FFFFFF">
<cfparam name="Attributes.textcolor"      default="000000">
<cfparam name="Attributes.roundBorder"    default="1">

<cfif attributes.startcolor neq "" and attributes.endcolor neq "">				
	<cfset attributes.startcolor = replace(attributes.startcolor,"##","","ALL")>
	<cfset attributes.endcolor = replace(attributes.endcolor,"##","","ALL")>
	
	<cfset vlist = "white=ffffff,black=000000,gray=808080,silver=c0c0c0,blue=005aff,green=006c0a,yellow=ffde00,red=ff0000,purple=9000ff,orange=d45602">
	
	<cfset aColor[1] = attributes.startcolor >
	<cfset aColor[2] = attributes.endcolor>				
	<!--- transforming values --->
	<cfloop index="k" from=1 to=2>
		<cfloop list="#vlist#" index="i">					
		<cfset aResult = ListToArray(i,"=")>					
			<cfloop index="j" from="1" to="#arrayLen(aResult)#">
				<cfif aColor[k]  eq aResult[j] and j eq 1>
					<cfif j+1 lte arrayLen(aResult)>
						<cfset aColor[k] = aResult[j+1]>					
					<cfelse>	
						<cfset aColor[k]  = aResult[j]>					
					</cfif>	
				</cfif>
			</cfloop>				
		</cfloop>
	</cfloop>
	<!--- end - transforming values --->			
	<cfset attributes.startcolor = aColor[1]>
	<cfset attributes.endcolor   = aColor[2]>	   
</cfif>

<cfset vBorderRadius = "8px">

<cfoutput>
	<cfsavecontent variable="vStyle">
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='###Attributes.startcolor#', endColorstr='###Attributes.endcolor#'); 
		background: -ms-linear-gradient(top, ###Attributes.startcolor# 0%, ###Attributes.startcolor# 20%, ###Attributes.endcolor# 100%);
		background: -webkit-linear-gradient(###Attributes.startcolor# 0%, ###Attributes.startcolor# 20%, ###Attributes.endcolor# 100%);
	    background: -o-linear-gradient(###Attributes.startcolor# 0%, ###Attributes.startcolor# 20%, ###Attributes.endcolor# 100%);
	    background: -moz-linear-gradient(###Attributes.startcolor# 0%, ###Attributes.startcolor# 20%, ###Attributes.endcolor# 100%);
    	background: linear-gradient(###Attributes.startcolor# 0%, ###Attributes.startcolor# 20%, ###Attributes.endcolor# 100%);
		
		width:#Attributes.TotalWidth#; 
		border:1px solid ###Attributes.endcolor#; 
		background-color: ###Attributes.startcolor#;
		
		<cfif Attributes.roundBorder eq 1>
			border-radius: #vBorderRadius#;
			-moz-border-radius: #vBorderRadius#;
			-webkit-border-radius: #vBorderRadius#;
			-ms-border-radius: #vBorderRadius#;
			-o-border-radius: #vBorderRadius#;
		</cfif>
	</cfsavecontent>
</cfoutput>

<cfif thisTag.ExecutionMode is "start">

	<cfoutput>
		<div style="#vStyle# overflow:none;">
			<div style="padding:5px; color:###Attributes.textcolor#; height:100%; overflow:none;">
	</cfoutput>

<cfelse>

			</div>	
		</div>
		
</cfif>