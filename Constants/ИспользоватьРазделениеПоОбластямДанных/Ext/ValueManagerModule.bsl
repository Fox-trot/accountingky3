﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	ДополнительныеСвойства.Вставить("ТекущееЗначение", Константы.ИспользоватьРазделениеПоОбластямДанных.Получить());
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	// Следующие константы взаимоисключающие, используются в отдельных функциональных опциях.
	//
	// Константа.ЭтоАвтономноеРабочееМесто                -> ФО.РаботаВАвтономномРежиме
	// Константа.НеИспользоватьРазделениеПоОбластямДанных -> ФО.РаботаВЛокальномРежиме
	// Константа.ИспользоватьРазделениеПоОбластямДанных   -> ФО.РаботаВМоделиСервиса.
	//
	// Имена констант сохранены для обратной совместимости.
	
	Если Значение Тогда
		
		Константы.НеИспользоватьРазделениеПоОбластямДанных.Установить(Ложь);
		Константы.ЭтоАвтономноеРабочееМесто.Установить(Ложь);
		
	ИначеЕсли Константы.ЭтоАвтономноеРабочееМесто.Получить() Тогда
		
		Константы.НеИспользоватьРазделениеПоОбластямДанных.Установить(Ложь);
		
	Иначе
		
		Константы.НеИспользоватьРазделениеПоОбластямДанных.Установить(Истина);
		
	КонецЕсли;
	
	Если ДополнительныеСвойства.ТекущееЗначение <> Значение Тогда
		
		ОбновитьПовторноИспользуемыеЗначения();
		
		Если Значение Тогда
			
			ИнтеграцияСтандартныхПодсистем.ПриВключенииРазделенияПоОбластямДанных();
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли