public with sharing class Calculate_SLA_Business_Hours {

    public class InputWrapper {
        @InvocableVariable(label='Data Inicial')
        public DateTime startDateTime;

        @InvocableVariable(label='Horas de SLA')
        public Integer slaHours;
    }

    public class OutputWrapper {
        @InvocableVariable(label='Prazo Calculado')
        public DateTime deadlineDateTime;
    }

    @InvocableMethod(label='Calcular Prazo SLA em Horário Comercial')
    public static List<OutputWrapper> calculateSLA(List<InputWrapper> requests) {
        List<OutputWrapper> results = new List<OutputWrapper>();

        for (InputWrapper request : requests) {
            OutputWrapper result = new OutputWrapper();
            result.deadlineDateTime = addBusiness_Hours(request.startDateTime, request.slaHours);
            results.add(result);
        }

        return results;
    }

    public static DateTime addBusiness_Hours(DateTime start, Integer hours) {
        Integer hoursRemaining = hours;
        DateTime currentDateTime = start;
        while (hoursRemaining > 0) {
            if (isBusinessDay(currentDateTime)) {
                if (isWithinBusinessHours(currentDateTime)) {
                    currentDateTime = currentDateTime.addHours(1);
                    hoursRemaining--;
                } else {
                    currentDateTime = getNextBusinessHour(currentDateTime);
                }
            } else {
                currentDateTime = getNextBusinessDay(currentDateTime);
            }
        }
        return currentDateTime;
    }

    public static Boolean isBusinessDay(DateTime dt) {
        DateTime localStartOfDay = DateTime.newInstance(dt.date(), Time.newInstance(0, 0, 0, 0));
        Integer dayOfWeek = Integer.valueOf(localStartOfDay.format('u')); // 1 = Monday, 7 = Sunday
        return dayOfWeek <= 5;
    }

    private static Boolean isWithinBusinessHours(DateTime dt) {
        Time t = dt.time();
        Time startOfficeHours = Time.newInstance(9, 0, 0, 0);
        Time endOfficeHours = Time.newInstance(18, 0, 0, 0);
        return t >= startOfficeHours && t < endOfficeHours;
    }

    private static DateTime getNextBusinessHour(DateTime dt) {
        Date d = dt.date();
        Time startOfficeHours = Time.newInstance(9, 0, 0, 0);
        if (dt.time() < startOfficeHours) {
            return DateTime.newInstance(d, startOfficeHours);
        } else {
            return getNextBusinessDay(dt);
        }
    }

    private static DateTime getNextBusinessDay(DateTime dt) {
        Date nextDay = dt.date().addDays(1);
        while (!isBusinessDay(DateTime.newInstance(nextDay, Time.newInstance(9, 0, 0, 0)))) {
            nextDay = nextDay.addDays(1);
        }
        return DateTime.newInstance(nextDay, Time.newInstance(9, 0, 0, 0));
    }
}