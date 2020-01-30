 
<cfoutput>

['<b>MY CLAIMS</b>',null, 

['<font color="FF0000">Unclaimed</font>','ClaimViewListing.cfm?Text=Unclaimed&ID1=Pending&ID=REQ&PersonNo=#Attributes.PersonNo#'], 

<!--- ['Travel claims',null, --->

['Pending Subm.','ClaimViewListing.cfm?Text=Pending submission&ID1=1&ID=STA&PersonNo=#Attributes.PersonNo#'], 

['Submitted','ClaimViewListing.cfm?Text=Submitted&ID1=2&ID=STA&PersonNo=#Attributes.PersonNo#'], 

['Settled','ClaimViewListing.cfm?Text=Settled&ID1=5&ID=STA&PersonNo=#Attributes.PersonNo#'], 

['<font color="silver">Uploaded</font>','ClaimViewListing.cfm?Text=Settled&ID1=6&ID=STA&PersonNo=#Attributes.PersonNo#'], 


['Supplementary','ClaimViewListing.cfm?Text=Supplementary&ID1=Pending&ID=SUP&PersonNo=#Attributes.PersonNo#'], 


<!--- ], --->

['Advanced search','ClaimViewOpen.cfm?Text=Advanced search&ID1=4&ID=STA&PersonNo=#Attributes.PersonNo#'], 

]

</cfoutput>


