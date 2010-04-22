#!/usr/bin/env python

from sqlalchemy import *
import sqlalchemy.engine

db = create_engine(sqlalchemy.engine.url.URL('mysql', username = 'iphone_S10',
   password = '#####', host = '127.0.0.1',
   port = '3307', database = 'iphone_obd2'), echo = False)

metadata = MetaData()
metadata.bind = db
metadata.reflect()
print metadata.tables['data']

