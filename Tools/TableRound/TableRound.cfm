	
	<cfparam name="Attributes.TotalWidth"     default="100%">       <!--- Total width of the main Table --->
	<cfparam name="Attributes.TotalHeight"    default="">          <!--- Total height of the main Table --->
	<cfparam name="Attributes.Background"     default="yes">        <!--- Includes a background in the content area --->
	<cfparam name="Attributes.Mode"           default="gradient">   <!--- Various modes are described below --->
	<cfparam name="Attributes.Color"          default="transparent" ><!--- Background color for the main table --->
	<cfparam name="Attributes.startcolor"     default="">             <!--- for gradient effect --->
	<cfparam name="Attributes.endcolor"       default="">
	<cfparam name="Attributes.Padding"        default="0">          <!--- Specifies padding for the content area --->
	<cfparam name="Attributes.Align"          default="center">     <!--- Alignment of the main Table --->
	<cfparam name="Attributes.vAlign"         default="top">     <!--- Alignment of the main Table --->
	<cfparam name="Attributes.Alt"            default="">     <!--- Alignment of the main Table --->
	<cfparam name="Attributes.onmouseover"    default="">     <!--- mouse over color change of table --->
	<cfparam name="Attributes.onmouseout"     default="">     <!--- mouse out color change of table --->
	<cfparam name="Attributes.id"     		  default="">     <!--- table id --->
	<cfparam name="Attributes.innerid"        default=""> 
	<cfparam name="Attributes.line"           default="0">
	<cfparam name="Attributes.onclick"     	  default="">     <!--- table onClick --->
	<cfparam name="Attributes.disable"        default="no"> <!--- dynamically disable rendering of the tableround --->
		
	<cfoutput>
	<!--- ----------------- --->
	<!--- HANDLE TABLE MODE --->
	<!--- ----------------- --->
		<cfif Attributes.Mode eq "gradient"><!--- gray glow around the table --->
			<cfset Attributes.Path = "#SESSION.root#/Images/Mail">
			<cfset wd = "15px">
			<cfset ht = "15px">
		<cfelseif Attributes.Mode eq "flat"><!--- gray glow around the table --->
			<cfset Attributes.Path = "#SESSION.root#/Images/Mail">
			<cfset wd = "15px">
			<cfset ht = "15px">	
		<cfelseif Attributes.Mode eq "gradientcolor"><!--- COLORED glow around the table, used against a WHITE background only --->
			<cfset Attributes.Path = "#SESSION.root#/Images/Mail/Gradient">
			<cfset wd = "12px">
			<cfset ht = "12px">
		<cfelseif Attributes.Mode eq "solid"><!--- translucid rounded table with white border, MUST BE USED against a VIVID or DARK Background --->
			<cfset Attributes.Path = "#SESSION.root#/Images/Mail/Nogradient">
			<cfset wd = "5px">
			<cfset ht = "5px">
		<cfelseif Attributes.Mode eq "solidcolor"><!--- Rounded COLORED table used against a WHITE background only --->
			<cfset Attributes.Path = "#SESSION.root#/Images/Mail/Nogradient/Color">
			<cfset wd = "6px">
			<cfset ht = "6px">
		<cfelseif Attributes.Mode eq "solidborder"><!--- Rounded white table with a colored BORDER, used against a WHITE background only--->
			<cfset Attributes.Path = "#SESSION.root#/Images/Mail/Nogradient/Border">
			<cfset wd = "5px">
			<cfset ht = "5px">
		<cfelseif Attributes.Mode eq "solidthick"><!--- Rounded white table with a thick colored BORDER and GRADIENT, used against a WHITE background only--->
			<cfset Attributes.Path = "#SESSION.root#/Images/Mail/Nogradient/Thick">
			<cfset wd = "22px">
			<cfset ht = "22px">
		<cfelseif Attributes.Mode eq "modal"><!--- Rounded gray transalucid border used most commonly for Modal windows--->
			<cfset Attributes.Path = "#SESSION.root#/Images/Mail/Nogradient/Modal">
			<cfset wd = "22px">
			<cfset ht = "22px">
		<cfelseif Attributes.Mode eq "custom"><!--- Custom table with catched path and size.--->
			<cfparam name="Attributes.Path" default="">
			<cfparam name="wd" default="10px">
			<cfparam name="ht" default="10px">
		<cfelse>
			<cfset Attributes.Path = "#SESSION.root#/Images/Mail">
			<cfset wd = "15px">
			<cfset ht = "15px">
		</cfif>
		
	<!--- ------------------------------ --->
	<!--- HANDLE startcolor and endcolor --->
	<!--- ------------------------------ --->
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
		
		<cfif attributes.disable eq "no">
			<cfif thisTag.ExecutionMode is "start">
			
				<table	width="#Attributes.TotalWidth#" 
						height="#Attributes.TotalHeight#" 
						border="0"
						align="#Attributes.Align#" 
						bgcolor="#Attributes.Color#" 
						<cfif attributes.mode neq "flat">
						style="border:#attributes.line#px solid silver;background-color:#attributes.color#; <cfif attributes.startcolor neq "" and attributes.endcolor neq "">
								filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='###attributes.startcolor#', endColorstr='###attributes.endcolor#'); /* for IE */
								background: -ms-linear-gradient(top, ###attributes.startcolor# 0%,###attributes.endcolor# 100%); /* IE10+ */
								background: -webkit-gradient(linear, left top, left bottom, from(###attributes.startcolor#), to(###attributes.endcolor#)); /* for webkit browsers */
								background: -moz-linear-gradient(top,  ###attributes.startcolor#,  ###attributes.endcolor#); /* for firefox 3.6+ */
								</cfif> "
						</cfif>		
						<cfif attributes.onmouseover neq "">
							onmouseover="#attributes.onmouseover#"
						</cfif>
						<cfif attributes.onmouseout neq "">
							onmouseout="#attributes.onmouseout#"
						</cfif>
						<cfif attributes.onclick neq "">
							onclick="#attributes.onclick#"
						</cfif>
					    title="#Attributes.Alt#" 
						id="#Attributes.id#"
						name="#Attributes.id#">
						
					<cfif attributes.mode eq "flat">
					
					<cfsavecontent variable="cl">
					
								<cfif attributes.startcolor neq '' and attributes.endcolor neq ''>
								filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='###attributes.startcolor#', endColorstr='###attributes.endcolor#'); /* for IE */
								background: -ms-linear-gradient(top, ###attributes.startcolor# 0%,###attributes.endcolor# 100%); /* IE10+ */
								background: -webkit-gradient(linear, left top, left bottom, from(###attributes.startcolor#), to(###attributes.endcolor#)); /* for webkit browsers */
								background: -moz-linear-gradient(top,  ###attributes.startcolor#,  ###attributes.endcolor#); /* for firefox 3.6+ */
								</cfif>		
					
					</cfsavecontent>
															
					<tr>
						<td width="2" style="#cl# border-top-left-radius:5px;border-bottom-left-radius:5px;"></td>
						<td valign="#Attributes.vAlign#" id="#attributes.innerid#" align="center" 
						style="padding:0;background-color:#attributes.color#;#cl#">	
										
					<cfelse>
					
					<tr>
						<td width="#wd#" height="#ht#" style="padding:0px; background-image:url('#Attributes.Path#/Border_top_left.png'); background-repeat:no-repeat; background-position:bottom right; line-height:#ht#"><img src="#Attributes.Path#/Transparent.png" width="#wd#" height="#ht#" style="display:block"></td>
						<td height="#ht#" style="padding:0px; background-image:url('#Attributes.Path#/Border_top.png'); background-repeat:repeat-x; background-position:bottom;"></td>
						<td width="#wd#" height="#ht#" style="padding:0px; background-image:url('#Attributes.Path#/Border_top_right.png'); background-repeat:no-repeat; background-position:bottom left; line-height:#ht#"><img src="#Attributes.Path#/Transparent.png" width="#wd#" height="#ht#" style="display:block"></td>
					</tr>
					
					<tr>
						<td width="#wd#" style="background-image:url('#Attributes.Path#/Border_left.png'); background-repeat:repeat-y; background-position:right;"></td>
						<td valign="#Attributes.vAlign#" id="#attributes.innerid#" align="center" style="padding:#Attributes.Padding#; <cfif Attributes.Background eq "yes">background-image:url('#Attributes.Path#/Background.png')</cfif>">	
										
					</cfif>	
					
			<cfelse>		
			
					<cfif attributes.mode eq "flat">
					
						</td>
						<td width="2" style="#cl#;border-top-right-radius:3px;border-bottom-right-radius:3px;border:1px solid silver;border-left:0px;"></td>
					</tr>					
										
					<cfelse>
					
						</td>
						<td width="#wd#" style="padding:0px; background-image:url('#Attributes.Path#/Border_right.png'); background-repeat:repeat-y; background-position:left;"></td>
					</tr>
					
					<tr>
						<td width="#wd#" height="#ht#" style="padding:0px; background-image:url('#Attributes.Path#/Border_bottom_left.png'); background-repeat:no-repeat; background-position:top right; line-height:#ht#"><img src="#Attributes.Path#/Transparent.png" width="#wd#" height="#ht#" style="display:block"></td>
						<td height="#ht#" style="padding:0px; background-image:url('#Attributes.Path#/Border_bottom.png'); background-repeat:repeat-x; background-position:top;"></td>
						<td width="#wd#" height="#ht#" style="padding:0px; background-image:url('#Attributes.Path#/Border_bottom_right.png'); background-repeat:no-repeat; background-position:top left; line-height:#ht#"><img src="#Attributes.Path#/Transparent.png" width="#wd#" height="#ht#" style="display:block"></td>
					</tr>					
					
					</cfif>				
					
				</table>
				
			</cfif>
		</cfif>
	</cfoutput>
	