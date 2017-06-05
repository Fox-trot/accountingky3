﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;		
	КонецЕсли;

	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ДанныеЗаполнения = Неопределено Тогда
		ДанныеЗаполнения = Новый Структура("Организация", БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Запись.СтавкаКорпОтчислений = 0 Тогда
			БухгалтерскийУчетСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "СчетУчетаРасчетовПрофВзнос");
		КонецЕсли;
	КонецЦикла
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли
