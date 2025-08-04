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


