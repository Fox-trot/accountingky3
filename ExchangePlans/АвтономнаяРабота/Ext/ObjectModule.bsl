﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДаннымиСервер.НадоВыполнитьОбработчикПослеЗагрузкиДанных(ЭтотОбъект, Ссылка) Тогда
		
		ПослеЗагрузкиДанных(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ПослеЗагрузкиДанных(Отказ)
	
	
КонецПроцедуры // ПослеЗагрузкиДанных()

#КонецЕсли