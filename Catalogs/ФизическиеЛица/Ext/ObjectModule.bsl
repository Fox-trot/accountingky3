﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПроцедурыИФункцииОбщегоНазначения

// Выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	// Дата рождения в допустимый интервал
	Если ЗначениеЗаполнено(ДатаРождения) Тогда 
		ТекущийГод = Год(ТекущаяДатаСеанса());
		ДатаРожденияГод = Год(ДатаРождения);
		
		Если ДатаРожденияГод >= ТекущийГод - 15
			Или ДатаРожденияГод <= ТекущийГод - 150 Тогда
			
			ТекстСообщения = НСтр("ru='не верно указана дата рождения.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект,"ДатаРождения",, Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

Процедура ПередЗаписью(Отказ)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ФИО)
		И НЕ Наименование = ФИО Тогда 
		Наименование = ФИО;	
	КонецЕсли;	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда 
		Возврат;
	КонецЕсли;	
	
	ВыполнитьПредварительныйКонтроль(Отказ);
КонецПроцедуры

#КонецОбласти

#КонецЕсли