# Example how to calculate tracked times from a CSV with pandas

import datetime
import pandas as pd


DAY = 0
MONTH = 1
YEAR = 2

HOUR = 0
MINUTE = 1


class WorkingDay:

    def __init__(self, namedtuple):
        self.free = isinstance(namedtuple.free, str)
        if not self.free:
            self.start = self.__construct_date__(namedtuple.date, namedtuple.start)
            self.end = self.__construct_date__(namedtuple.date, namedtuple.end)
            self.breaktime = namedtuple.breaktime
        else:
            self.start = None
            self.end = None
            self.breaktime = 0

    @staticmethod
    def __construct_date__(day_str, time_str):
        day = [int(i) for i in day_str.split("-")]
        time = [int(i) for i in time_str.split(":")]
        return datetime.datetime(year=day[YEAR] + 2000, month=day[MONTH],
                                 day=day[DAY], hour=time[HOUR], minute=time[MINUTE])

    def __str__(self):
        return f"{WorkingDay.__name__}: start={self.start}, end={self.end}, breaktime={self.breaktime}, " \
               f"free={self.free}"

    def worked_hours(self):
        hours = 8.0
        if not self.free:
            minutes = ((self.end - self.start) - datetime.timedelta(minutes=self.breaktime)).total_seconds()
            hours = minutes / 60 / 60
        return hours


if __name__ == '__main__':
    """ Example content of .timetracking.csv:
        date,start,end,breaktime,free
        20-01-19,08:00,16:30,30,
        21-01-19,,,,vacation
    """

    working_days = pd.read_csv("./.timetracking.csv")
    total_overtime = 0

    for row in working_days.itertuples(index=False):
        wd = WorkingDay(row)
        total_overtime += wd.worked_hours() - 8.0

    print(f"Total overtime: {total_overtime}")

