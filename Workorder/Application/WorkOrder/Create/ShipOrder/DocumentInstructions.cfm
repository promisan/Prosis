<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->


<cfset buttonlayout = {Label="Print Instructions", mode="silver", width="160px", color= "636334", iconheight= "15px", fontsize= "11px", paddingleft = "5px"}>
<table style="width:100%; height:100%">
	<tr>
		<td align="right" style="padding-right:50px">
			<cf_print buttonlayout="#buttonlayout#" mode="largeroundedbutton" >
		</td>
	</tr>
	<tr>
		<td align="center">
			
			<cf_printcontent>				
			<table width="85%" align="center">
				<tr>
					<td>
						<cfoutput>
						<img src="#session.root#/custom/kuntz/website/images/Kuntz_Logo.png">
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td height="30px" style="height:30px">
					</td>
				</tr>
				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td> 
									
									<table cellpadding="0" cellspacing="0" border="0" width="100%">    
										<tr>
											<td  height="5px"></td>
										</tr>
									
										<tr>
									    	<td  valign="middle" class="labellarge">
											<b>
											<cfif client.languageid eq "ENG">Kuntz Deliveries Portal for participating Branches
											<cfelseif client.languageid eq "NED">U bent op het invoerscherm voor consumentenbezorgingen van Kuntz B.V. Bedrijfsdiensten
											<cfelseif client.languageid eq "ESP">Not Defined
											<cfelseif client.languageid eq "FRA">NOT DEFINED
											</cfif>
											</b>        
											<hr>
											</td>
									    </tr>   
										<tr><td  height="5px"></td></tr>
										
										<tr>
											<td>
											<table cellpadding="0" cellspacing="0" border="0" width="100%">
												<tr>
											    	<td class="labelmedium" style="color:black;">
													<cfif client.languageid eq "ENG">		
					Under Construction
					<br><Br>
													<cfelseif client.languageid eq "NED">
					Kuntz B.V. Bedrijfsdiensten biedt haar opdrachtgevers een compleet en oplossinggericht pakket aan mogelijkheden voor hun consumentenbezorgingen.
					<br>
					Hieronder volgt een uitleg van onze werkwijze.
					<br><br>
					U kunt u in de daarvoor bestemde velden alle relevante gegevens van uw klant invullen. Als u het mobiele nummer van de klant invoert, ontvangt de klant de avond voorafgaande aan de bezorging een sms met informatie over de bezorgtijd, de naam van de bezorger en ons telefoonnummer. Bezorgtijden worden aangegeven in blokken van 2 uur. Klanten die alleen een vast telefoonnummer opgeven, kunnen ons op de bezorgdag 's ochtends vanaf 8.00 uur bellen om naar de bezorgtijd te informeren. Tevens zijn de bezorgtijden terug te vinden op onze website.
					<br><br>
					<span style="font-size:18px">
					<b>Hoe vind u de bezorgtijden van uw klanten ?</b>
					</span>
					<br><br>
					U kunt inloggen via het inlogportaal en daar de voor uw filiaal geplande bezorgingen en bezorgtijden raadplegen of op onze website kijken.
					<br><br>
					Ook consumenten kunnen op onze website terecht voor hun actuele bezorgtijd. 
					
					<br><br>
					<span style="font-size:18px">
					Servicemodules
					</span>
					<br><br>
					Wij bieden klanten, indien overeengekomen, de mogelijkheid consumenten 3 standaard servicemodules aan te bieden.
					<br><br><table width="100%" cellspacing="0" cellpadding="0"  style="padding:7px;border:1px dotted silver">
						<tr>
						    <td style="width:3%; border-bottom:0px dotted silver">1.</td>
							<td class="labelit" style="width:42%; padding-right:8px; border-bottom:0px dotted silver">Meenemen van pallets (prijs per pallet)</td>
							<td class="labelit" style="width:55%; border-bottom:0px dotted silver; border-left:1px dotted silver; padding:3px 0px 3px 10px">Pallets worden naast de auto gelost, verder gebracht als met een pompwagen mogelijk is en daar afgestapeld</td>
						</tr>
						<tr>
							<td style="border-bottom:0px dotted silver">2.</td>
							<td class="labelit" style="border-bottom:0px dotted silver;padding-right:8px;">Verder bezorgen dan de 1e drempel op de begane grond</td>
							<td class="labelit" style="border-bottom:0px dotted silver; border-left:1px dotted silver; padding:3px 0px 3px 10px">Goederen worden naar de 1e etage of indien een lift aanwezig verder naar boven</td>
						</tr>
						<tr>
							<td style="border-bottom:0px dotted silver">3.</td>
							<td class="labelit" style="border-bottom:0px dotted silver;padding-right:8px;">Over afstanden tot maximaal 30 meter van de auto bezorgen</td>
							<td class="labelit" style="border-left:1px dotted silver; padding:3px 0px 3px 10px">Denkt U hierbij bijvoorbeeld aan het bezorgen in de (achter) tuin</td>
						</tr>
					</table>
					<br>
					<span style="font-size:18px; text-align:center">
					VOOR "MAATWERK" AFSPRAKEN KUNT U CONTACT MET ONS OPNEMEN VIA 070 307 7773
					</span>
					
					
													<cfelseif client.languageid eq "ESP">Texto no definido
													<cfelseif client.languageid eq "FRA">NOT DEFINED
													</cfif>
													</td>
												</tr>
											</table>
									        </td>
									    </tr>					
									</table>
									
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</cf_printcontent>
		</td>
	</tr>
</table>							



