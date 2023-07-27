<cfparam name="url.search"       default = "">

<cfparam name="url.country"      default = "">
<cfparam name="url.zoomlevel"    default = "15">
<cfparam name="url.postalcode"   default = "">

<cfparam name="url.mode"         default = "edit">
<cfparam name="url.scope"        default = "dialog">
<cfparam name="url.city"         default = "">
<cfparam name="url.address"      default = "">

<cfparam name="url.latitude"     default="">
<cfparam name="url.longitude"    default="">
<cfparam name="url.width"        default="400">
<cfparam name="url.height"       default="392">
<cfparam name="url.format"       default="map">

<!---
<cfif url.latitude eq "" and url.country eq "">
	<cfset url.latitude =  "45">
	<cfset url.longitude = "-45">	
</cfif>
--->

<cfparam name="url.markerbind"   default="">

<cfquery name="Country"
		datasource="appsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT  *
		FROM    Ref_Nation
		WHERE   Code = '#url.country#'		
</cfquery>

<cfif url.latitude neq "" and url.longitude neq "">

	<cfset lat = url.latitude>
	<cfset lng = url.longitude>
	

	<!--- Hanno 07/12/2011 : limit the search here as the method is giving issues --->
	
	<cfinvoke component="service.maps.googlegeocoder3" 
	          method="googlegeocoder3" 
			  returnvariable="details">	  	
			  <cfinvokeargument name="latlng" value="#lat#,#lng#">			
			  <cfinvokeargument name="ShowDetails" value="false">			  
	</cfinvoke>
	
	<!---	
	<cfdump var="#details#">
	--->
	

	<cfset lat = details.latitude>
	<cfset lng = details.longitude>
	<cfset sts = details.status>		
	
<cfelse>
			
	<cfinvoke component="service.maps.googlegeocoder3" 
	          method="googlegeocoder3" 
			  returnvariable="details">
			 			  
			  <cfif len(url.postalcode) gte 5>						  
				   <cfset search = "#Country.Name#, #url.city# #url.postalcode# #url.address#">						
			  <cfelse>
				   <cfset search = "#Country.Name#, #url.city# #url.address#">				
   			</cfif>
			
			<cfinvokeargument name="address" value="#search#">			  
	      			  
			<cfinvokeargument name="ShowDetails" value="false">
			  
	</cfinvoke>	 
		
	<cfset lat = details.latitude>
	<cfset lng = details.longitude>
	<cfset sts = details.status>
	
	
</cfif>

<cfoutput>

<cfif sts neq "OK">
	
	<table width="98%" height="100%" valign="top">
				
		<tr>
		<td align="center"   			
		    id="maploc"
			valign="top"
		    style="border:1px dotted gray;height:100%;padding-top:6px" class="labelmedium"><cf_tl id="Location not found">
						
			</td>
		</tr>		
						
	</table>
	
<cfelse>
	
	<table width="#url.width-20#" height="100%" align="center">
		
	<tr><td align="center" class="labelit" style="border-top:1px solid silver">
			  	
			<cfif lat eq "">
				<cfset lat = "0">				
				<cfset lng = "0">
				
			</cfif>		
									
			<cfmap name="gmap"
			    centerlatitude="#lat#"
			    centerlongitude="#lng#"
			    doubleclickzoom="true"
				collapsible="false"
			    overview="true"
				continuousZoom="true"
				height="#url.height+10#"
				width="#url.width-20#"
				typecontrol="advanced"
				hideborder="true"
				type="#url.format#"
			    scrollwheelzoom="false"
				showmarkerwindow="true"
			    showscale="true"
			    tip="#details.Formatted_Address#"
			    zoomlevel="#url.zoomlevel#"/>
	</td></tr>	
	
	<cfif details.formatted_address neq "">
	
	<tr>
	<td bgcolor="f4f4f4" align="center"   		
	    style="border-left:1px solid silver;border-right:1px solid silver;border-bottom:1px solid silver">
		<table width="100%"><tr><td align="center" style="height:40px;border-bottom:0px solid silver" 
		   class="labelmedium" id="maploc">				  	    
		   #details.Formatted_Address# 
		</td></tr>
		</table>
	</td>
	
	</tr>
	
	</cfif>
		
	<cfif url.mode eq "edit" or url.search eq "Yes">
				<tr>
		
		  <td height="15" colspan="2" align="center" style="padding-right:14px;border-left:1px solid silver;border-right:1px solid silver;border-bottom:1px solid silver"> 
		  
			  <table class="formpadding">
			  
			  <tr class="labelmedium2 fixlengthlist">
			  <cfif url.scope neq "dialog">
			  <td align="center" style="padding-left:10px">
			  <a href="javascript:getmap('#url.scope#')"><cf_tl id="Apply"></a>
			  </td>		
			  <td align="center">|</td>							  
			  </cfif>
			  <td align="center"><a href="javascript:mapaddress('#url.scope#')"><cf_tl id="Show Address"></a></td>		
			  <td align="center">|</td>		 
			  <td align="center"><a href="javascript:mapcoord('#url.scope#')"><cf_tl id="Show Coordinates"></a></td>		
						 			  
			  <cfif url.scope eq "dialog">
			  		  
				  <td id="info">
				    <input type="hidden" name="cLatitude"  id="cLatitude"  value="#lat#" class="regular" style="width:110;text-align:center" readonly> 
					<input type="hidden" name="cLongitude" id="cLongitude" value="#lng#" style="width:110;text-align:center" class="regular" readonly>
				  </td>	 				  
				  <td align="right" style="padding-right:3px" class="labelit"> 	  
					  <a href="javascript:getcoordinates()"><font color="black"><b><cf_tl id="Apply"></a>
				  </td>
				  
			  <cfelse>
			  
			          <script>
			  		   try {
					   document.getElementById('cLatitude').value  = #lat#	 
					   document.getElementById('cLongitude').value = #lng#	
					   } catch(e) {}	  
					  </script> 
				  
			   </cfif>
			   			   
			  </table>
			  
		  </td>
		  
		</tr>
		
	</cfif>
				
	</table>		
			
</cfif>		



</cfoutput>

