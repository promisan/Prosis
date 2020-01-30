
<!--- ------------------------------------ --->
<!--- This approach takes 1 sec on the server --->
<!--- side to resolve could be more on other --->
<!--- networks consider db driven approach --->
<!--- instead using a scheduled task that --->
<!--- collects weather information --->
<!--- ----------------------------------- --->

<cfparam name="url.city" default="guatemala">

<cfquery name="qRelatedCities" datasource="AppsEmployee">
	SELECT BirthCity as City, N.Name as Country
	FROM Person P INNER JOIN System.dbo.UserNames U
	       ON P.PersonNo = U.PersonNo LEFT JOIN System.dbo.Ref_Nation N
		   ON N.Code = P.BirthNationality
	WHERE
		U.Account = '#SESSION.acc#'
		UNION
		
			SELECT Distinct AddressCity, N.Name
			FROM vwPersonAddress V LEFT JOIN System.dbo.Ref_Nation N
				   ON N.Code = V.Country
			WHERE 
			PersonNo IN
				(
					SELECT P.PersonNo
					FROM Person P INNER JOIN System.dbo.UserNames U
					ON P.PersonNo = U.PersonNo
					WHERE
					U.Account = '#SESSION.acc#'
				)
</cfquery>


<cfset cnt = "0">

	<cfloop query="qRelatedCities">
		<cfset url.city = "#City#, #Country#">
		<cfset _Error  = FALSE>
		
		<cftry>
		
			<cfhttp 
				url="http://free.worldweatheronline.com/feed/weather.ashx?q=#url.city#&format=xml&num_of_days=2&key=50eb3f781e234114120207"
				result="qweather" 
				method="get" 
				charset="utf-8">
		
			<cfset varXML=XMLParse(qweather.fileContent)>
			<cfset XML_City        = varXML.data.XMLChildren[1].XMLChildren[2].XmlText>
			<cfset XML_Centigrades = varXML.data.XMLChildren[2].XMLChildren[2].XmlText>
			<cfset XML_Farenheith  = varXML.data.XMLChildren[2].XMLChildren[3].XmlText>
			<cfset XML_Image       = varXML.data.XMLChildren[2].XMLChildren[5].XmlText>
			<cfset XML_Description = varXML.data.XMLChildren[2].XMLChildren[6].XmlText>
			
			<cfcatch>
				<cfset _Error = TRUE>
			</cfcatch>
		</cftry>
			
		
		
		
		<cfif NOT _Error>
		
			<cfset cnt = cnt+1>			
			<cfif cnt lt "4">
		
			<cfoutput>
			
			<cfset url.city = replace(url.city,",","","ALL")>
			<cfset url.city = replace(url.city, " ", "","ALL")>
			
			<div class="wcontainer" id="#url.city#" >
				<div class="widrelwrapper">
				<table cellpadding="0px" cellspacing="0px" width="100%">
					<tr>
						<td colspan="2" style="font-size:12px; padding-bottom:5px;">#XML_City#</td>
					</tr>
		
					<tr>
						<td class="wimage" style="background-image:url('#XML_Image#'); ">
						</td>
						<td style="padding-left:5px">
							<table cellpadding="0px" cellspacing="0px" height="60px">
								<tr>
									<td width="5px">C:</td><td class="stats">#XML_Centigrades#</td><td width="5px">F:</td><td class="stats">#XML_Farenheith#</td>
								</tr>	
				
								<tr>
									<td colspan="4" style="padding-top:5px">#XML_Description#</td>
								</tr>
							</table>
						</td>
					</tr>
					
				</table>
				<cfoutput>
				<div class="widgetclose" onclick="widgetclose('#url.city#','')">X</div>
				</cfoutput>
				</div>
			</div>
				
		
			</cfoutput>
			</cfif>
		
		<cfelse>
			<!--- used so if no content if brough up by the AJAX call it will not trigger and error retrieving an empty template --->
			<span style="display:none">&nbsp;</span>
		</cfif>

</cfloop>

