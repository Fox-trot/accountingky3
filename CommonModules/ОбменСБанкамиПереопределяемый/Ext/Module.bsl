﻿
////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиПереопределяемый: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет массив актуальными видами электронных документов для прикладного решения.
//
// Параметры:
//  Массив - Массив - виды актуальных ЭД:
//   * Перечисления.ВидыЭДОбменСБанками - вид электронного документа.
//   Добавлять можно только следующие значения:
//    - Перечисления.ВидыЭДОбменСБанками.ЗапросВыписки
//    - Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение
//    - Перечисления.ВидыЭДОбменСБанками.ПлатежноеТребование
//    - Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПереводВалюты
//    - Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПокупкуВалюты
//    - Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПродажуВалюты
//    - Перечисления.ВидыЭДОбменСБанками.РаспоряжениеНаОбязательнуюПродажуВалюты
//    - Перечисления.ВидыЭДОбменСБанками.СписокНаЗачислениеДенежныхСредствНаСчетаСотрудников
//    - Перечисления.ВидыЭДОбменСБанками.СписокНаОткрытиеСчетовПоЗарплатномуПроекту
//    - Перечисления.ВидыЭДОбменСБанками.СписокУволенныхСотрудников
//    - Перечисления.ВидыЭДОбменСБанками.Письмо
//
Процедура ПолучитьАктуальныеВидыЭД(Массив) Экспорт
	
КонецПроцедуры

// Используется для получения номеров счетов в виде массив строк
//
// Параметры:
//  Организация - СправочникСсылка.Организации - отбор по организации.
//  Банк - СправочникСсылка.КлассификаторБанков - отбор по банку.
//  МассивНомеровБанковскихСчетов - Массив - Массив возврата, в элементах строки с номерами счетов.
//
Процедура ПолучитьНомераБанковскихСчетов(Организация, Банк, МассивНомеровБанковскихСчетов) Экспорт
	
КонецПроцедуры

// Определяет параметры электронного документа по типу владельца.
//
// Параметры:
//  Источник - ДокументСсылка, ДокументОбъект - Источник объекта, либо ссылка документа/справочника-источника.
//  ПараметрыЭД - Структура - структура параметров источника, необходимых для определения
//                настроек обмена ЭД. Обязательные параметры: ВидЭД, Банк, Организация.
//
Процедура ЗаполнитьПараметрыЭДПоИсточнику(Источник, ПараметрыЭД) Экспорт
	// БПКР
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("ДокументСсылка.ПлатежноеПоручениеИсходящее")
		ИЛИ ТипИсточника = Тип("ДокументОбъект.ПлатежноеПоручениеИсходящее") Тогда
	
		//Если Источник.ТипПлатежногоДокумента = Перечисления._ДемоТипыПлатежныхДокументов.ПлатежноеПоручение Тогда
			ПараметрыЭД.ВидЭД = Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение;
		//ИначеЕсли Источник.ТипПлатежногоДокумента = Перечисления._ДемоТипыПлатежныхДокументов.ПлатежноеТребование Тогда
		//	ПараметрыЭД.ВидЭД = Перечисления.ВидыЭДОбменСБанками.ПлатежноеТребование;
		//КонецЕсли;
		ПараметрыЭД.Организация = Источник.Организация;
		ПараметрыЭД.Банк = Источник.БанковскийСчет.Банк;
	КонецЕсли;
	// Конец БПКР
КонецПроцедуры

// Подготавливает данные для электронного документа типа Платежное поручение.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПлатежноеПоручение из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПлатежныхПоручений(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	// БПКР
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПлатежноеПоручение.Дата КАК Дата,
	|	ПлатежноеПоручение.СуммаДокумента КАК Сумма,
	|	ПлатежноеПоручение.Контрагент.НаименованиеПолное КАК РеквизитыПолучателя_Наименование,
	|	ПлатежноеПоручение.Контрагент.ИНН КАК РеквизитыПолучателя_ИНН,
	|	ПлатежноеПоручение.БанковскийСчетПолучателя.НомерСчета КАК РеквизитыПолучателя_РасчСчет,
	|	ПлатежноеПоручение.БанковскийСчетПолучателя.Банк.Код КАК РеквизитыПолучателя_Банк_БИК,
	|	ПлатежноеПоручение.БанковскийСчетПолучателя.Банк.Наименование КАК РеквизитыПолучателя_Банк_Наименование,
	|	ПлатежноеПоручение.БанковскийСчетПолучателя.Банк.Адрес КАК РеквизитыПолучателя_Банк_Город,
	|	ПлатежноеПоручение.БанковскийСчетПолучателя.Банк.КоррСчет КАК РеквизитыПолучателя_Банк_КоррСчет,
	|	ПлатежноеПоручение.Организация.Наименование КАК РеквизитыПлательщика_Наименование,
	|	ПлатежноеПоручение.Организация.ИНН КАК РеквизитыПлательщика_ИНН,
	|	ПлатежноеПоручение.БанковскийСчет.НомерСчета КАК РеквизитыПлательщика_РасчСчет,
	|	ПлатежноеПоручение.БанковскийСчет.Банк.Код КАК РеквизитыПлательщика_Банк_БИК,
	|	ПлатежноеПоручение.БанковскийСчет.Банк.Наименование КАК РеквизитыПлательщика_Банк_Наименование,
	|	ПлатежноеПоручение.БанковскийСчет.Банк.Адрес КАК РеквизитыПлательщика_Банк_Город,
	|	ПлатежноеПоручение.БанковскийСчет.Банк.КоррСчет КАК РеквизитыПлательщика_Банк_КоррСчет,
	|	""Электронно"" КАК РеквизитыПлатежа_ВидПлатежа,
	|	""01"" КАК РеквизитыПлатежа_ВидОплаты,
	|	1 КАК РеквизитыПлатежа_Очередность,
	|	"""" КАК РеквизитыПлатежа_Код,
	|	ПлатежноеПоручение.НазначениеПлатежа КАК РеквизитыПлатежа_НазначениеПлатежа,
	|	ПлатежноеПоручение.Контрагент КАК Получатель,
	|	ПлатежноеПоручение.ТипОперации КАК ТипОперации,
	|	Ложь КАК ПеречислениеВБюджет,
	|	"""" КАК ПлатежиВБюджет_СтатусСоставителя,
	|	"""" КАК ПлатежиВБюджет_ПоказательКБК,
	|	"""" КАК ПлатежиВБюджет_ОКТМО,
	|	"""" КАК ПлатежиВБюджет_ПоказательОснования,
	|	""0"" КАК ПлатежиВБюджет_ПоказательПериода,
	|	""0"" КАК ПлатежиВБюджет_ПоказательНомера,
	|	""0"" КАК ПлатежиВБюджет_ПоказательДаты
	|ИЗ
	|	Документ.ПлатежноеПоручениеИсходящее КАК ПлатежноеПоручение
	|ГДЕ
	|	ПлатежноеПоручение.Ссылка В (&МассивСсылок)";
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	ТаблицаДанныхДокумента = Запрос.Выполнить().Выгрузить();
	
	СтрокаДанных = ТаблицаДанныхДокумента[0];
	Индекс = 0;
	
	Для Индекс = 0 По 23 Цикл
		Путь = СтрЗаменить(ТаблицаДанныхДокумента.Колонки[Индекс].Имя, "_", ".");
		ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДанныеДляЗаполнения[0], Путь, СтрокаДанных[Индекс]);
	КонецЦикла;
	
	Если СтрокаДанных.ПеречислениеВБюджет Тогда
		Для Индекс = 26 По 32 Цикл
			Путь = СтрЗаменить(ТаблицаДанныхДокумента.Колонки[Индекс].Имя, "_", ".");
			ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДанныеДляЗаполнения[0], Путь, СтрокаДанных[Индекс]);
		КонецЦикла;
	КонецЕсли;

	ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДанныеДляЗаполнения[0], "Получатель", СтрокаДанных.Получатель);	
	// Конец БПКР
КонецПроцедуры

// Подготавливает данные для электронного документа типа Платежное требование.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПлатежноеТребование из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПлатежныхТребований(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	// БПКР
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПлатежноеТребование.Дата КАК Дата,
	|	ПлатежноеТребование.СуммаДокумента КАК Сумма,
	|	ПлатежноеТребование.Контрагент.НаименованиеПолное КАК РеквизитыПлательщика_Наименование,
	|	ПлатежноеТребование.Контрагент.ИНН КАК РеквизитыПлательщика_ИНН,
	|	ПлатежноеТребование.БанковскийСчетПолучателя.НомерСчета КАК РеквизитыПлательщика_РасчСчет,
	|	ПлатежноеТребование.БанковскийСчетПолучателя.Банк.Код КАК РеквизитыПлательщика_Банк_БИК,
	|	ПлатежноеТребование.БанковскийСчетПолучателя.Банк.Наименование КАК РеквизитыПлательщика_Банк_Наименование,
	|	ПлатежноеТребование.БанковскийСчетПолучателя.Банк.Адрес КАК РеквизитыПлательщика_Банк_Город,
	|	ПлатежноеТребование.БанковскийСчетПолучателя.Банк.КоррСчет КАК РеквизитыПлательщика_Банк_КоррСчет,
	|	ПлатежноеТребование.Организация.Наименование КАК РеквизитыПолучателя_Наименование,
	|	ПлатежноеТребование.Организация.ИНН КАК РеквизитыПолучателя_ИНН,
	|	ПлатежноеТребование.БанковскийСчет.НомерСчета КАК РеквизитыПолучателя_РасчСчет,
	|	ПлатежноеТребование.БанковскийСчет.Банк.Код КАК РеквизитыПолучателя_Банк_БИК,
	|	ПлатежноеТребование.БанковскийСчет.Банк.Наименование КАК РеквизитыПолучателя_Банк_Наименование,
	|	ПлатежноеТребование.БанковскийСчет.Банк.Адрес КАК РеквизитыПолучателя_Банк_Город,
	|	ПлатежноеТребование.БанковскийСчет.Банк.КоррСчет КАК РеквизитыПолучателя_Банк_КоррСчет,
	|	""Электронно"" КАК РеквизитыПлатежа_ВидПлатежа,
	|	""02"" КАК РеквизитыПлатежа_ВидОплаты,
	|	1 КАК РеквизитыПлатежа_Очередность,
	|	ПлатежноеТребование.НазначениеПлатежа КАК РеквизитыПлатежа_НазначениеПлатежа,
	|	"""" КАК РеквизитыПлатежа_Код,
	|	1 КАК УсловиеОплаты,
	|	"""" КАК СрокАкцепта,
	|	ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0) КАК ДатаОтсылкиДокументов,
	|	ПлатежноеТребование.Контрагент КАК Плательщик,
	|	ПлатежноеТребование.ТипОперации КАК ТипОперации
	|ИЗ
	|	Документ.ПлатежноеПоручениеИсходящее КАК ПлатежноеТребование
	|ГДЕ
	|	ПлатежноеТребование.Ссылка = &Ссылка";
	
	//Запрос.УстановитьПараметр("Ссылка", СсылкаНаОбъект);
	ТаблицаДанныхДокумента = Запрос.Выполнить().Выгрузить();
	
	СтрокаДанных = ТаблицаДанныхДокумента[0];
	Индекс = 0;
	
	Для Индекс = 0 По 25 Цикл
		Путь = СтрЗаменить(ТаблицаДанныхДокумента.Колонки[Индекс].Имя, "_", ".");
		//ЭлектронноеВзаимодействие.ЗаполнитьЗначениеРеквизитаВДереве(ДеревоДокумента, Путь, СтрокаДанных[Индекс]);
	КонецЦикла;
	// Конец БПКР
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на перевод валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПереводВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПорученийНаПереводВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на покупку валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПокупкуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПорученийНаПокупкуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Поручение на продажу валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета ПоручениеНаПродажуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеПорученийНаПродажуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Распоряжение на обязательную продажу валюты.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета РаспоряжениеНаОбязательнуюПродажуВалюты из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеРаспоряженийНаОбязательнуюПродажуВалюты(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Подготавливает данные для электронного документа типа Справка о подтверждающих документах.
//
// Параметры:
//  МассивСсылок - Массив - содержит ссылки на документы информационной базы, на основании которых будут созданы электронные документы.
//  ДанныеДляЗаполнения - Массив - содержит пустые деревья значений, которые необходимо заполнить данными.
//           Дерево значений повторяет структуру макета СправкаОПодтверждающихДокументах из обработки ОбменСБанками.
//           Если по какому-либо документу не удалось получить данные, то текст ошибки необходимо поместить вместо дерева значений.
//           ВНИМАНИЕ! Порядок элементов массива ДанныеДляЗаполнения соответствует порядку элементов массива МассивСсылок.
//
Процедура ЗаполнитьДанныеСправокОПодтверждающихДокументах(МассивСсылок, ДанныеДляЗаполнения) Экспорт
	
КонецПроцедуры

// Вызывается при получении уведомления о зачислении валюты
//
// Параметры:
//  ДеревоРазбора - ДеревоЗначений - дерево данных, соответствующее макету Обработки.ОбменСБанками.УведомлениеОЗачислении
//  НовыйДокументСсылка - ДокументСсылка - ссылка на созданный документ на основании данных электронного документа.
//
Процедура ПриПолученииУведомленияОЗачислении(ДеревоРазбора, НовыйДокументСсылка) Экспорт
	
КонецПроцедуры

// Заполняет список команд ЭДО.
// 
// Параметры:
//  СоставКомандЭДО - Массив - например "Документ.ПлатежныйДокумент".
//
Процедура ПодготовитьСтруктуруОбъектовКомандЭДО(СоставКомандЭДО) Экспорт
	//БПКР
	СоставКомандЭДО.Добавить("Документ.ПлатежноеПоручениеИсходящее");
	// Конец БПКР
КонецПроцедуры

// Включает тестовый режим обмена в банком.
// При включении тестового режима возможно ручное указание URL сервера для получения настроек обмена.
//
// Параметры:
//    ИспользуетсяТестовыйРежим - Булево - признак использования тестового режима.
//
Процедура ПроверитьИспользованиеТестовогоРежима(ИспользуетсяТестовыйРежим) Экспорт
	
КонецПроцедуры

// Событие возникает при получении выписки из регламентного задания или при синхронизации.
// Необходимо создать документы в информационной базе для отражения произведенных по счету операций.
// Для получения данных выписки в удобном формате можно использовать следующие процедуры:
//  - ОбменСБанками.ПолучитьДанныеВыпискиБанкаДеревоЗначений()
//  - ОбменСБанками.ПолучитьДанныеВыпискиБанкаТекстовыйФормат() - только для рублевых выписок.
//
// Параметры:
//  СообщениеОбмена - ДокументСсылка.СообщениеОбменСБанками - ссылка на сообщение обмена, содержащий выписку банка.
//
Процедура ПриПолученииВыписки(СообщениеОбмена) Экспорт
	
КонецПроцедуры

#Область ЗарплатныйПроект

// Вызывается для формирования XML файла в прикладном решении.
//
// Параметры:
//    ОбъектДляВыгрузки - ДокументСсылка - ссылка на документ, на основании которого будет сформирован ЭД.
//    ИмяФайла - Строка - имя сформированного файла.
//    АдресФайла - АдресВременногоХранилища - содержит двоичные данные файла.
//
Процедура ПриФормированииXMLФайла(ОбъектДляВыгрузки, ИмяФайла, АдресФайла) Экспорт
	
КонецПроцедуры

// Формирует табличный документ на основании файла XML для визуального отображения электронного документа.
//
// Параметры:
//  ИмяФайла - Строка - полный путь к файлу XML
//  ТабличныйДокумент - ТабличныйДокумент - возвращаемое значение, визуальное отображение данных файла.
//
Процедура ЗаполнитьТабличныйДокумент(Знач ИмяФайла, ТабличныйДокумент) Экспорт
	
КонецПроцедуры

// Вызывается при получении файла из банка.
//
// Параметры:
//  АдресДанныхФайла - Строка - адрес временного хранилища с двоичными данными файла.
//  ИмяФайла - Строка - формализованное имя файла данных.
//  ОбъектВладелец - ДокументСсылка - (возвращаемый параметр) ссылка на документ, который был создан на основании ЭД.
//  ДанныеОповещения - Структура - (возвращаемый параметр) данные для вызова метода Оповестить на клиенте.
//                 * Ключ - Строка - имя события.
//                 * Значение - Произвольный - параметр сообщения.
Процедура ПриПолученииXMLФайла(АдресДанныхФайла, ИмяФайла, ОбъектВладелец, ДанныеОповещения) Экспорт
	
КонецПроцедуры

// Вызывается при изменении состояния электронного документооборота.
//
// Параметры:
//  СсылкаНаОбъект - ДокументСсылка - владелец электронного документооборота;
//  СостояниеЭД - ПеречислениеСсылка.СостоянияОбменСБанками - новое состояние электронного документооборота.
//
Процедура ПриИзмененииСостоянияЭД(СсылкаНаОбъект, СостояниеЭД) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

