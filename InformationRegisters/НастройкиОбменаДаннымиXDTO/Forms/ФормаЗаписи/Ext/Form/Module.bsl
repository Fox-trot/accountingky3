﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МенеджерЗаписи = РегистрыСведений.НастройкиОбменаДаннымиXDTO.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись.ИсходныйКлючЗаписи);
	МенеджерЗаписи.Прочитать();
	
	ХранилищеНастройки = МенеджерЗаписи.Настройки.Получить();
	Если Не ХранилищеНастройки = Неопределено Тогда
		ПоддерживаемыеОбъекты.Загрузить(ХранилищеНастройки);
	КонецЕсли;
	
	ХранилищеНастройкиКорреспондента = МенеджерЗаписи.НастройкиКорреспондента.Получить();
	Если Не ХранилищеНастройкиКорреспондента = Неопределено Тогда
		ПоддерживаемыеОбъектыКорреспондента.Загрузить(ХранилищеНастройкиКорреспондента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
