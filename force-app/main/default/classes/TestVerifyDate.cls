@IsTest
private class TestVerifyDate {
	@Istest
    static void testCheckDatesDateLessThan30() {
        Date date1 = Date.newInstance(2019, 9, 20);
        Date date2 = Date.newInstance(2019, 10, 19);
        Date date3 = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(date2, date3);
    }
    @Istest
    static void testCheckDatesDateEquals30() {
        Date date1 = Date.newInstance(2019, 9, 20);
        Date date2 = Date.newInstance(2019, 10, 20);
        Date date3 = VerifyDate.CheckDates(date1, date2);
        Integer month = date1.month();
        Integer year = date1.year();
        Integer day = date1.day();
		Integer numberDays = date.daysInMonth(year, month);
        Date date4 = Date.newInstance(year, month, numberDays);
        System.assertEquals(date4, date3);
    }
    @Istest
    static void testCheckDatesDateGreaterThan30() {
        Date date1 = Date.newInstance(2019, 9, 20);
        Date date2 = Date.newInstance(2019, 10, 21);
        Date date3 = VerifyDate.CheckDates(date1, date2);
         Integer month = date1.month();
        Integer year = date1.year();
        Integer day = date1.day();
		Integer numberDays = date.daysInMonth(year, month);
        Date date4 = Date.newInstance(year, month, numberDays);
        System.assertEquals(date4, date3);
    }
        
    @Istest
    static void testCheckDatesDate2LessThanDate1() {
        Date date1 = Date.newInstance(2019, 10, 20);
        Date date2 = Date.newInstance(2019, 9, 19);
        Date date3 = VerifyDate.CheckDates(date1, date2);
        Integer month = date1.month();
        Integer year = date1.year();
        Integer day = date1.day();
		Integer numberDays = date.daysInMonth(year, month);
        Date date4 = Date.newInstance(year, month, numberDays);
        System.assertEquals(date4, date3);
    }
    
}