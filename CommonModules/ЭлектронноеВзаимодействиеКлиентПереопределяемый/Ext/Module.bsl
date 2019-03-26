﻿
////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеКлиентПереопределяемый: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет сообщение о нехватке прав доступа.
//
// Параметры:
//  ТекстСообщения - Строка - текст сообщения.
//
Процедура ПодготовитьТекстСообщенияОНарушенииПравДоступа(ТекстСообщения) Экспорт
	
	// При необходимости можно переопределить или дополнить текст сообщения
	
КонецПроцедуры

// Выполняет интерактивное проведение документов перед формированием ЭД.
// Если есть непроведенные документы, предлагает выполнить проведение. Спрашивает
// пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры:
//  ДокументыМассив - Массив - Ссылки на документы, которые требуется провести перед печатью.
//                             После выполнения функции из массива исключаются непроведенные документы.
//  ОбработкаПродолжения - ОписаниеОповещения - содержит описание процедуры,
//                         которая будет вызвана после завершения проверки документов.
//  ФормаИсточник - УправляемаяФорма - форма, из которой была вызвана команда.
//
Процедура ВыполнитьПроверкуПроведенияДокументов(ДокументыМассив, ОбработкаПродолжения, ФормаИсточник = Неопределено) Экспорт
	ОчиститьСообщения();
	ПроводимыеДокументы = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.МассивПроводимыхДокументов(ДокументыМассив);
	ДокументыТребующиеПроведение = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ПроводимыеДокументы);
	КоличествоНепроведенныхДокументов = ДокументыТребующиеПроведение.Количество();
	
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		
		Если КоличествоНепроведенныхДокументов = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронную версию документа, его необходимо предварительно провести.
			|Выполнить проведение документа и продолжить?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Для того чтобы сформировать электронные версии документов, их необходимо предварительно провести.
			|Выполнить проведение документов и продолжить?'");
		КонецЕсли;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОбработкаПродолжения", ОбработкаПродолжения);
		ДополнительныеПараметры.Вставить("ДокументыТребующиеПроведение", ДокументыТребующиеПроведение);
		ДополнительныеПараметры.Вставить("ФормаИсточник", ФормаИсточник);
		ДополнительныеПараметры.Вставить("ДокументыМассив", ДокументыМассив);
		Обработчик = Новый ОписаниеОповещения("ВыполнитьПроверкуПроведенияДокументовПродолжить", ЭтотОбъект, ДополнительныеПараметры);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВыполнитьПроверкуПроведенияДокументовПродолжить(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	ДокументыМассив = Неопределено;
	ОбработкаПродолжения = Неопределено;
	ДокументыТребующиеПроведение = Неопределено;
	Если Результат = КодВозвратаДиалога.Да
		И ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ДокументыМассив", ДокументыМассив)
		И ДополнительныеПараметры.Свойство("ОбработкаПродолжения", ОбработкаПродолжения)
		И ДополнительныеПараметры.Свойство("ДокументыТребующиеПроведение", ДокументыТребующиеПроведение) Тогда
		
		ФормаИсточник = Неопределено;
		ДополнительныеПараметры.Свойство("ФормаИсточник", ФормаИсточник);
		
		ДанныеОНепроведенныхДокументах = ОбщегоНазначенияВызовСервера.ПровестиДокументы(ДокументыТребующиеПроведение);
		
		// Cообщаем о документах, которые не провелись.
		ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен: %2 Формирование ЭД невозможно.'");
		НепроведенныеДокументы = Новый Массив;
		Для Каждого ИнформацияОДокументе Из ДанныеОНепроведенныхДокументах Цикл
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
																	ШаблонСообщения,
																	Строка(ИнформацияОДокументе.Ссылка),
																	ИнформацияОДокументе.ОписаниеОшибки);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ИнформацияОДокументе.Ссылка);
			НепроведенныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);
		КонецЦикла;
		
		КоличествоНепроведенныхДокументов = НепроведенныеДокументы.Количество();
		
		// Оповещаем открытые формы о том, что были проведены документы.
		ПроведенныеДокументы = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыТребующиеПроведение,
																			НепроведенныеДокументы);
		ТипыПроведенныхДокументов = Новый Соответствие;
		Для Каждого ПроведенныйДокумент Из ПроведенныеДокументы Цикл
			ТипыПроведенныхДокументов.Вставить(ТипЗнч(ПроведенныйДокумент));
		КонецЦикла;
		Для Каждого Тип Из ТипыПроведенныхДокументов Цикл
			ОповеститьОбИзменении(Тип.Ключ);
		КонецЦикла;
		
		Оповестить("ОбновитьДокументИБПослеЗаполнения", ПроведенныеДокументы);
		
		// Обновляем исходный массив документов.
		ДокументыМассив = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ДокументыМассив, НепроведенныеДокументы);
		ЕстьДокументыГотовыеДляФормированияЭД = ДокументыМассив.Количество() > 0;
		Если КоличествоНепроведенныхДокументов > 0 Тогда
			
			// Спрашиваем пользователя о необходимости продолжения печати при наличии непроведенных документов.
			ТекстВопроса = НСтр("ru = 'Не удалось провести один или несколько документов.'");
			КнопкиДиалога = Новый СписокЗначений;
			
			Если ЕстьДокументыГотовыеДляФормированияЭД Тогда
				ТекстВопроса = ТекстВопроса + " " + НСтр("ru = 'Продолжить?'");
				КнопкиДиалога.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Продолжить'"));
				КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена);
			Иначе
				КнопкиДиалога.Добавить(КодВозвратаДиалога.ОК);
			КонецЕсли;
			ДопПараметры = Новый Структура("ОбработкаПродолжения, ДокументыМассив", ОбработкаПродолжения, ДокументыМассив);
			Обработчик = Новый ОписаниеОповещения("ВыполнитьПроверкуПроведенияДокументовЗавершить", ЭтотОбъект, ДопПараметры);
			ПоказатьВопрос(Обработчик, ТекстВопроса, КнопкиДиалога);
		Иначе
			ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
		КонецЕсли;
		Оповестить("ОбновитьСостояниеЭД");
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПроверкуПроведенияДокументовЗавершить(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	ДокументыМассив = Неопределено;
	
	ОбработкаПродолжения = Неопределено;
	Если Результат = КодВозвратаДиалога.Пропустить
		И ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ДокументыМассив", ДокументыМассив)
		И ДополнительныеПараметры.Свойство("ОбработкаПродолжения", ОбработкаПродолжения) Тогда
		
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения, ДокументыМассив);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
