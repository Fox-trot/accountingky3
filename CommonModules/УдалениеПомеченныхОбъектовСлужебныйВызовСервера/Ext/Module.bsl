﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Устанавливает режим автоматического удаления помеченных объектов
//   
Функция УстановитьРежимУдалятьПоРасписанию(УдалятьПомеченныеОбъекты) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(,, Ложь) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для совершения операции.'");
	КонецЕсли;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные", Метаданные.РегламентныеЗадания.УдалениеПомеченных);
	Задания = РегламентныеЗаданияСервер.НайтиЗадания(Отбор);
	
	Для Каждого Задание Из Задания Цикл 
		
		Параметры = Новый Структура;
		Параметры.Вставить("Использование", УдалятьПомеченныеОбъекты);
		РегламентныеЗаданияСервер.ИзменитьЗадание(Задание, Параметры);
		
		Возврат Истина;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// (См. УдалениеПомеченныхОбъектов.ЗначениеФлажкаУдалятьПоРасписанию)
//
Функция ЗначениеФлажкаУдалятьПоРасписанию() Экспорт
	
	Возврат УдалениеПомеченныхОбъектов.ЗначениеФлажкаУдалятьПоРасписанию();
	
КонецФункции

#КонецОбласти