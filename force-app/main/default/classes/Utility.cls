public class Utility {
    
    public static Date getFutureDateExcludeWeekends(Date fromDate, Integer numberOfBusinessDays){
        if(numberOfBusinessDays == 0){
            return fromDate;
        }
        DateTime dateTime_FromDate = DateTime.newInstance(fromDate.year(), fromDate.month(), fromDate.day());
        String dayOfTheWeek_FromDate = dateTime_FromDate.format('E');
        Integer businessDaysLeftInTheWeek = 0;
        Integer totalDaysLeftInTheWeek = 0;
        Integer modulus = 0;
        Integer offset = 0;
        Integer numberOfActualDaysToBeAdded = 0;
        switch on dayOfTheWeek_FromDate {
            when 'Mon' {
                businessDaysLeftInTheWeek = 4;
                totalDaysLeftInTheWeek = businessDaysLeftInTheWeek +2;
            }
            when 'Tue' {
                businessDaysLeftInTheWeek = 3;
                totalDaysLeftInTheWeek = businessDaysLeftInTheWeek +2;
            }
            when 'Wed' {
                businessDaysLeftInTheWeek = 2;
                totalDaysLeftInTheWeek = businessDaysLeftInTheWeek +2;
            }
            when 'Thu' {
                businessDaysLeftInTheWeek = 1;
                totalDaysLeftInTheWeek = businessDaysLeftInTheWeek +2;
            }
            when 'Fri' {
                totalDaysLeftInTheWeek = 2;
            }
            when 'Sat' {
                totalDaysLeftInTheWeek = 1;
            }
            when 'Sun' {
                totalDaysLeftInTheWeek = 0;
            }		
        }
        modulus = Math.round((numberOfBusinessDays-businessDaysLeftInTheWeek)/5);
        offset  = Math.mod((numberOfBusinessDays-businessDaysLeftInTheWeek), 5);
        if(offset==0){
            numberOfActualDaysToBeAdded = ((modulus-1)*7)+5+totalDaysLeftInTheWeek;
        } else {
            numberOfActualDaysToBeAdded = (modulus*7)+offset+totalDaysLeftInTheWeek;
        }
        return fromDate.addDays(numberOfActualDaysToBeAdded);
    }
    
    /***** Formula *****/
    /* IF(WEEKDAY(FromDate__c)==1,
		FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5),
		IF(WEEKDAY(FromDate__c)==7,
			FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5) + 1,
			CASE(WEEKDAY(FromDate__c),
				2, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5),
				3, CASE(MOD(NumberOfDaysToBeAddedd__c, 5),
						1, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5),
						2, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5),
						3, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5),
						4, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5)+2,					
						NULL
					),
				4, CASE(MOD(NumberOfDaysToBeAddedd__c, 5),
						1, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5),
						2, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5)+2,
						3, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5)+2,
						4, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5)+2,					
						NULL
					),
				5, CASE(MOD(NumberOfDaysToBeAddedd__c, 5),
						1, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5),
						2, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5),
						3, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5)+2,
						4, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5)+2,					
						NULL
					),
				6, FromDate__c + (MFLOOR(NumberOfDaysToBeAddedd__c/5)*7) + MOD(NumberOfDaysToBeAddedd__c, 5),
				NULL
			)
		)
	)
	*/
}