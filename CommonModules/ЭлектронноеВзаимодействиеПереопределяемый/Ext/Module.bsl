﻿

////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеПереопределяемый: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура возвращает данные для заполнения заявки на получение уникального
// идентификатора абонента, добавления сертификата абонента.
//
// Параметры:
//  Организация - Произвольный - ссылка на элемент справочника Организации;
//  ДанныеОрганизации - Структура - данные об организации:
//    * Индекс - Строка - почтовый индекс организации.
//    * Регион - Строка - код региона организации.
//    * Район - Строка - Район.
//    * Город - Строка - Город.
//    * НаселенныйПункт - Строка - населенный пункт расположения организации.
//    * Улица - Строка - Улица.
//    * Дом - Строка - Дом.
//    * Корпус - Строка - Корпус.
//    * Квартира - Строка - Квартира.
//    * Телефон - Строка - телефон организации.
//    * Наименование - Строка - наименование организации.
//    * ИНН - Строка - ИНН организации.
//    * КПП - Строка - КПП организации.
//    * ОГРН - Строка - ОГРН организации.
//    * КодИМНС - Строка - код ИМНС организации.
//    * ЮрФизЛицо - Строка - вид лица, возможные значения: "ЮрЛицо" или "ФизЛицо".
//    * Фамилия - Строка - фамилия руководителя.
//    * Имя - Строка - имя руководителя.
//    * Отчество - Строка - отчество руководителя.
//
// Пример:
//
////// Пример для "Управление торговлей 11"
//
//	ОрганизацияОбъект = Неопределено;
//	Попытка
//		ОрганизацияОбъект = Организация.ПолучитьОбъект();
//	Исключение
//	КонецПопытки;
//
//	ДанныеОрганизации.Очистить();
//
////// Возвращаемая структура должна содержать все перечисленные ниже
////// ключи и их значения - строки
////// Проверка свойств в дальнейшем не выполняется.
//
//	ДанныеОрганизации.Вставить("ОрганизацияСсылка", Организация);
//
//// в конфигурации "Управление торговлей" не реализовано хранение
//// компонентов адреса, поэтому компоненты адреса остаются пустыми.
//
//	ДанныеОрганизации.Вставить("Индекс"         , "");
//	ДанныеОрганизации.Вставить("Регион"         , "");
//	ДанныеОрганизации.Вставить("Район"          , "");
//	ДанныеОрганизации.Вставить("Город"          , "");
//	ДанныеОрганизации.Вставить("НаселенныйПункт", "");
//	ДанныеОрганизации.Вставить("Улица"          , "");
//	ДанныеОрганизации.Вставить("Дом"            , "");
//	ДанныеОрганизации.Вставить("Корпус"         , "");
//	ДанныеОрганизации.Вставить("Квартира"       , "");
//
//	Если ОрганизацияОбъект = Неопределено Тогда
//		
//		ДанныеОрганизации.Вставить("Наименование"   , "");
//		ДанныеОрганизации.Вставить("ИНН"            , "");
//		ДанныеОрганизации.Вставить("КПП"            , "");
//		ДанныеОрганизации.Вставить("ОГРН"           , "");
//		ДанныеОрганизации.Вставить("КодИМНС"        , "");
//		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ЮрЛицо");
//		
//		ДанныеОрганизации.Вставить("Фамилия"        , "");
//		ДанныеОрганизации.Вставить("Имя"            , "");
//		ДанныеОрганизации.Вставить("Отчество"       , "");
//	
//		Возврат;
//		
//	КонецЕсли;
//
//// получение реквизитов организации
//
//	ДанныеОрганизации.Вставить("Наименование"   , ОрганизацияОбъект.НаименованиеПолное);
//	ДанныеОрганизации.Вставить("ИНН"            , ОрганизацияОбъект.ИНН);
//	ДанныеОрганизации.Вставить("КПП"            , ОрганизацияОбъект.КПП);
//	ДанныеОрганизации.Вставить("ОГРН"           , ОрганизацияОбъект.ОГРН);
//	ДанныеОрганизации.Вставить("КодИМНС"        , "");
//
//	ВидыЛиц = Перечисления.ЮрФизЛицо;
//	Если ОрганизацияОбъект.ЮрФизЛицо = ВидыЛиц.ЮрЛицо
//		ИЛИ ОрганизацияОбъект.ЮрФизЛицо = ВидыЛиц.ЮрЛицоНеРезидент Тогда
//		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ЮрЛицо");
//	Иначе
//		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ФизЛицо");
//	КонецЕсли;
//
//	ДанныеОрганизации.Вставить("Фамилия" , "");
//	ДанныеОрганизации.Вставить("Имя"     , "");
//	ДанныеОрганизации.Вставить("Отчество", "");
//
//	Руководитель = ОрганизацияОбъект.ТекущийРуководитель;
//	Если НЕ Руководитель.Пустая() Тогда
//		
//		ФИОМассив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Руководитель.Наименование, " ");
//		КоличествоЭлементов = ФИОМассив.Количество();
//		
//		Если КоличествоЭлементов > 0 Тогда
//			ДанныеОрганизации.Фамилия = ФИОМассив[0];
//		КонецЕсли;
//		
//		Если КоличествоЭлементов > 1 Тогда
//			ДанныеОрганизации.Имя = ФИОМассив[1];
//		КонецЕсли;
//		
//		Если КоличествоЭлементов > 2 Тогда
//			ДанныеОрганизации.Отчество = ФИОМассив[2];
//		КонецЕсли;
//		
//	КонецЕсли;
//
//	ДанныеОрганизации.Вставить("Телефон", "");
//
//	СтруктураПоиска = Новый Структура;
//	СтруктураПоиска.Вставить("Тип", Перечисления.ТипыКонтактнойИнформации.Телефон);
//	СтруктураПоиска.Вставить("Вид", Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации);
//	СтрокиТелефона = ОрганизацияОбъект.КонтактнаяИнформация.НайтиСтроки(СтруктураПоиска);
//
//	Если СтрокиТелефона.Количество() > 0 Тогда
//		ДанныеОрганизации.Телефон = СтрокиТелефона[0].НомерТелефона;
//	КонецЕсли;
//
//
////// Пример для "Бухгалтерия предприятия, редакция 3.0":
//
//	СвойстваОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, 
//			"НаименованиеПолное, ИНН, КПП, ОГРН, КодНалоговогоОргана, ЮридическоеФизическоеЛицо");
//	
//	ОрганизацияФизЛицо = СвойстваОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
//	
//	ДанныеОрганизации.Вставить("ОрганизацияСсылка", Организация);
//	
//	ДанныеОрганизации.Вставить("Наименование"   , СвойстваОрганизации.НаименованиеПолное);
//	ДанныеОрганизации.Вставить("ИНН"            , СвойстваОрганизации.ИНН);
//	ДанныеОрганизации.Вставить("КПП"            , СвойстваОрганизации.КПП);
//	ДанныеОрганизации.Вставить("ОГРН"           , СвойстваОрганизации.ОГРН);
//	ДанныеОрганизации.Вставить("КодИМНС"        , СвойстваОрганизации.КодНалоговогоОргана);
//	
//	Если ОрганизацияФизЛицо Тогда
//		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ФизЛицо");
//	Иначе
//		ДанныеОрганизации.Вставить("ЮрФизЛицо"      , "ЮрЛицо");
//	КонецЕсли;
//	
//	ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(Организация, ТекущаяДатаСеанса());
//	ДанныеОрганизации.Вставить("Фамилия" , ОтветственныеЛица.РуководительФИО.Фамилия);
//	ДанныеОрганизации.Вставить("Имя"     , ОтветственныеЛица.РуководительФИО.Имя);
//	ДанныеОрганизации.Вставить("Отчество", ОтветственныеЛица.РуководительФИО.Отчество);
//	
//
//	Если ОрганизацияФизЛицо Тогда
//		ОбъектКонтактнойИнформации = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Организация, "ИндивидуальныйПредприниматель");
//		ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица;
//		ИмяСправочника = "ФизическиеЛица";
//	Иначе
//		ОбъектКонтактнойИнформации = Организация;
//		ВидКонтактнойИнформации = Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации;
//		ИмяСправочника = "Организации";
//	КонецЕсли;
//	
//	ДанныеОрганизации.Вставить("Индекс"         , "");
//	ДанныеОрганизации.Вставить("Регион"         , "");
//	ДанныеОрганизации.Вставить("КодРегиона"     , "");
//	ДанныеОрганизации.Вставить("Район"          , "");
//	ДанныеОрганизации.Вставить("Город"          , "");
//	ДанныеОрганизации.Вставить("НаселенныйПункт", "");
//	ДанныеОрганизации.Вставить("Улица"          , "");
//	ДанныеОрганизации.Вставить("Дом"            , "");
//	ДанныеОрганизации.Вставить("Корпус"         , "");
//	ДанныеОрганизации.Вставить("Квартира"       , "");
//	
//	ТекстЗапроса =
//	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
//	|	КонтактнаяИнформация.Значение
//	|ИЗ
//	|	Справочник." + ИмяСправочника + ".КонтактнаяИнформация КАК КонтактнаяИнформация
//	|ГДЕ
//	|	КонтактнаяИнформация.Ссылка = &Ссылка
//	|	И КонтактнаяИнформация.Вид = &Вид";
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = ТекстЗапроса;
//	Запрос.УстановитьПараметр("Ссылка", ОбъектКонтактнойИнформации);
//	Запрос.УстановитьПараметр("Вид",    ВидКонтактнойИнформации);
//	Выборка = Запрос.Выполнить().Выбрать();
//	Если Выборка.Следующий() Тогда
//		
//		АдресСтруктурой = РаботаСАдресами.СведенияОбАдресе(Выборка.Значение);
//		Если АдресСтруктурой.Свойство("Индекс") Тогда
//			ДанныеОрганизации.Индекс = АдресСтруктурой.Индекс;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Регион") Тогда
//			ДанныеОрганизации.Регион = АдресСтруктурой.Регион;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("КодРегиона") Тогда
//			ДанныеОрганизации.КодРегиона = АдресСтруктурой.КодРегиона;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Район") Тогда
//			ДанныеОрганизации.Район = АдресСтруктурой.Район;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Город") Тогда
//			ДанныеОрганизации.Город = АдресСтруктурой.Город;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("НаселенныйПункт") Тогда
//			ДанныеОрганизации.НаселенныйПункт = АдресСтруктурой.НаселенныйПункт;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Улица") Тогда
//			ДанныеОрганизации.Улица = АдресСтруктурой.Улица;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Здание") И ЗначениеЗаполнено(АдресСтруктурой.Здание) Тогда
//			ДанныеОрганизации.Дом = АдресСтруктурой.Здание.Номер;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Корпуса") И ЗначениеЗаполнено(АдресСтруктурой.Корпуса) Тогда
//			ДанныеОрганизации.Корпус = АдресСтруктурой.Корпуса[0].Номер;
//		КонецЕсли;
//		Если АдресСтруктурой.Свойство("Помещения") И ЗначениеЗаполнено(АдресСтруктурой.Помещения) Тогда
//			ДанныеОрганизации.Квартира = АдресСтруктурой.Помещения[0].Номер;
//		КонецЕсли;
//		
//	КонецЕсли;
//	
//	ДанныеОрганизации.Вставить("Телефон", УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
//				Организация, ?(ОрганизацияФизЛицо, Справочники.ВидыКонтактнойИнформации.ТелефонРабочийФизическиеЛица, Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации)));
//
Процедура ЗаполнитьРегистрационныеДанныеОрганизации(Организация, ДанныеОрганизации) Экспорт
	
КонецПроцедуры

// Изменяет поведение элементов управляемой или обычной формы.
//
// Параметры:
//  Форма - УправляемаяФорма, ОбычнаяФорма - управляемая или обычная форма для изменения.
//  СтруктураПараметров - Структура - параметры процедуры.
//
Процедура ИзменитьСвойстваЭлементовФормы(Форма, СтруктураПараметров) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка метаданных

// Определяет соответствие функциональных опций библиотеки и прикладного решения,
// в случае различий в наименовании.
//
// Параметры:
//  СоответствиеФО - Соответствие - список функциональных опций.
//
Процедура ПолучитьСоответствиеФункциональныхОпций(СоответствиеФО) Экспорт
	
КонецПроцедуры

// Определяет соответствие справочников библиотеки и прикладного решения.
//
// Параметры:
//  СоответствиеСправочников - Соответствие - список справочников.
//
// Пример:
//    СоответствиеСправочников.Вставить("Организации",                 "Организации");
//    СоответствиеСправочников.Вставить("Контрагенты",                 "Контрагенты");
//    СоответствиеСправочников.Вставить("ДоговорыКонтрагентов",        "ДоговорыКонтрагентов");
//    СоответствиеСправочников.Вставить("Номенклатура",                "Номенклатура");
//    СоответствиеСправочников.Вставить("ЕдиницыИзмерения",            "ЕдиницыИзмерения");
//    СоответствиеСправочников.Вставить("НоменклатураПоставщиков",     "НоменклатураПоставщиков");
//    СоответствиеСправочников.Вставить("Валюты",                      "Валюты");
//    СоответствиеСправочников.Вставить("Банки",                       "КлассификаторБанков");
//    СоответствиеСправочников.Вставить("БанковскиеСчетаОрганизаций",  "БанковскиеСчета");
//    СоответствиеСправочников.Вставить("БанковскиеСчетаКонтрагентов", "БанковскиеСчета");
//    СоответствиеСправочников.Вставить("УпаковкиНоменклатуры",        "ЕдиницыИзмерения");
//    СоответствиеСправочников.Вставить("ФизическиеЛица",              "ФизическиеЛица");
//    СоответствиеСправочников.Вставить("Партнеры",                    "Партнеры");
//    СоответствиеСправочников.Вставить("ХарактеристикиНоменклатуры",  "ХарактеристикиНоменклатуры");
//
Процедура ПолучитьСоответствиеСправочников(СоответствиеСправочников) Экспорт
	// Электронные документы
	СоответствиеСправочников.Вставить("Банки",  "Банки");
	СоответствиеСправочников.Вставить("Валюты", "Валюты");
	// Конец электронные документы
	
	СоответствиеСправочников.Вставить("Контрагенты",                 "Контрагенты");
	СоответствиеСправочников.Вставить("Организации",                 "Организации");
	СоответствиеСправочников.Вставить("ДоговорыКонтрагентов",        "ДоговорыКонтрагентов");
	СоответствиеСправочников.Вставить("Номенклатура",                "Номенклатура");
	СоответствиеСправочников.Вставить("ЕдиницыИзмерения",            "ЕдиницыИзмерения");
	СоответствиеСправочников.Вставить("НоменклатураПоставщиков",     "Номенклатура");
	СоответствиеСправочников.Вставить("БанковскиеСчетаОрганизаций",  "БанковскиеСчета");
	СоответствиеСправочников.Вставить("БанковскиеСчетаКонтрагентов", "БанковскиеСчета");
	СоответствиеСправочников.Вставить("УпаковкиНоменклатуры",        "ЕдиницыИзмерения");
	//СоответствиеСправочников.Вставить("ФизическиеЛица",              "Пользователи");
КонецПроцедуры

// В процедуре формируется соответствие для сопоставления имен переменных библиотеки,
// наименованиям объектов и реквизитов метаданных прикладного решения.
// Если в прикладном решении есть документы, на основании которых формируется ЭД,
// причем названия реквизитов данных документов отличаются от общепринятых "Организация", "Контрагент", "СуммаДокумента",
// то для этих реквизитов необходимо добавить в соответствие записи виде:
// Ключ = "ДокументВМетаданных.ОбщепринятоеНазваниеРеквизита", Значение - "ДокументВМетаданных.ДругоеНазваниеРеквизита".
// Например:
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Организация", "МЗ_Покупка.Учреждение");
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Контрагент",  "МЗ_Покупка.Грузоотправитель");
//  СоответствиеРеквизитовОбъекта.Вставить("СчетФактураВыданный.СуммаДокумента",  "СчетФактураВыданный.Основание.СуммаДокумента");
// 
// Для подсистемы ОбменСБанками требуется определение следующих полей:
//   "ПлатежноеПоручениеВМетаданных" (необязательное)
//   "БанковскийСчетОрганизации.Закрыт" (необязательное)
//   "ИНН" (обязательное)
//   "СокращенноеНаименованиеОрганизации" (необязательное)
//   "БанковскийСчетОрганизации.Организация" (обязательное для писем)
//   "БанковскийСчетОрганизации.Банк" (обязательное для писем)
//   "ПлатежноеПоручение.СчетОрганизации" (обязательное для писем)
//   "ПлатежноеПоручение.Организация" (обязательное для писем)
//
// Параметры:
//  СоответствиеРеквизитовОбъекта - Соответствие - содержит:
//    * Ключ - Строка - имя переменной, используемой в коде библиотеки;
//    * Значение - Строка - наименование объекта метаданных или реквизита объекта в прикладном решении.
//
Процедура ПолучитьСоответствиеНаименованийОбъектовМДИРеквизитов(СоответствиеРеквизитовОбъекта) Экспорт
	// Обмен с банками начало
	СоответствиеРеквизитовОбъекта.Вставить("ПлатежноеПоручениеВМетаданных",      "_ДемоПлатежныйДокумент");
	СоответствиеРеквизитовОбъекта.Вставить("ПлатежноеТребованиеВМетаданных",     "_ДемоПлатежныйДокумент");
	СоответствиеРеквизитовОбъекта.Вставить("БанковскийСчетОрганизации",          "СчетОрганизации");
	СоответствиеРеквизитовОбъекта.Вставить("СокращенноеНаименованиеОрганизации", "Наименование");
	
	СоответствиеРеквизитовОбъекта.Вставить("ПлатежноеПоручение.СчетОрганизации", "СчетОрганизации");
	СоответствиеРеквизитовОбъекта.Вставить("ПлатежноеПоручение.Организация",     "Организация");
	СоответствиеРеквизитовОбъекта.Вставить("БанковскийСчетОрганизации.Банк",               "Банк");
	СоответствиеРеквизитовОбъекта.Вставить("БанковскийСчетОрганизации.Организация",        "Владелец");
	// Обмен с банками конец
КонецПроцедуры

// Определяет соответствие кодов обязательных элементов схем электронных документов их пользовательскому представлению.
//
// Параметры:
//  СоответствиеВозврата - Соответствие - исходное соответствие для заполнения.
//
Процедура СоответствиеКодовРеквизитовИПредставлений(СоответствиеВозврата) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Получение текстовых сообщений

// Определяет текст сообщения о необходимости настройки системы в зависимости от вида операции.
//
// Параметры:
//  ВидОперации    - строка - признак выполняемой операции;
//  ТекстСообщения - строка - текст сообщения.
//
Процедура ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации, ТекстСообщения) Экспорт
	
КонецПроцедуры

// Переопределяет выводимое сообщение об ошибке.
//
// Параметры:
//  КодОшибки - строка - код ошибки
//  ТекстОшибки - строка - измененный текст ошибки.
//
Процедура ИзменитьСообщениеОбОшибке(КодОшибки, ТекстОшибки) Экспорт
	
КонецПроцедуры

// Переопределяет сообщение о нехватке прав доступа.
//
// Параметры:
//  ТекстСообщения - Строка - текст сообщения.
//
Процедура ПодготовитьТекстСообщенияОНарушенииПравДоступа(ТекстСообщения) Экспорт
	
	// При необходимости можно переопределить или дополнить текст сообщения
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Получение данных

// Находит ссылку на объект ИБ по типу, ИД и дополнительным реквизитам.
// 
// Параметры:
//  ТипОбъекта - Строка - идентификатор типа объекта, который необходимо найти;
//  ИДОбъекта - Строка - идентификатор объекта заданного типа;
//  ДополнительныеРеквизиты - Структура - набор дополнительных полей объекта для поиска;
//  Результат - Ссылка - ссылка на найденный объект.
//
Процедура НайтиСсылкуНаОбъект(ТипОбъекта, Результат, ИдОбъекта = "", ДополнительныеРеквизиты = Неопределено) Экспорт
	
КонецПроцедуры

// Получает печатный номер документа.
//
// Параметры:
//  СсылкаНаОбъект - ДокументСсылка - ссылка на документ информационной базы.
//  Результат - Строка - номер документа.
//
Процедура ПолучитьПечатныйНомерДокумента(СсылкаНаОбъект, Результат) Экспорт
	
КонецПроцедуры

// Проверяет, готовность документов ИБ для формирования ЭД, и удаляет из массива не готовые документы.
//
// Параметры:
//  ДокументыМассив - Массив   - ссылки на документы, которые должны быть проверены перед формированием ЭД.
//
Процедура ПроверитьГотовностьИсточников(ДокументыМассив) Экспорт
	
КонецПроцедуры

// Получает данные о физическом (юридическом) лице по ссылке.
//
// Параметры:
//  ЮрФизЛицо - Ссылка - ссылка на элемент справочника, по которому надо получить данные.
//  Сведения - Структура - данные юридического (физического лица).
//
Процедура ПолучитьДанныеЮрФизЛица(ЮрФизЛицо, Сведения) Экспорт
	
КонецПроцедуры

// Возвращает текстовое описание организации по параметрам.
//
// Параметры:
//  СведенияОрганизации - Структура - сведения об организации, по которой надо составить описание.
//  Список - Строка - список запрашиваемых параметров организации.
//  СПрефиксом - Булево - признак вывода префикса параметра организации.
//  Результат - Строка - описание организации.
//
Процедура ОписаниеОрганизации(СведенияОрганизации, Результат, Список = "", СПрефиксом = Истина) Экспорт
	
КонецПроцедуры

// Проверяет наличие прав на открытие журнала регистрации.
//
// Параметры:
//  Результат - Булево - если пользователь имеет право на открытие журнала регистрации,
//                       в этой переменной должна быть установлена Истина.
//
Процедура ЕстьПравоОткрытияЖурналаРегистрации(Результат) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с электронными документами

// Выполняется перед записью владельца электронного документа,
// который может служить основанием для исходящего электронного документа. 
// При этом должна существовать действующая настройка ЭДО между организацией и контрагентом, указанными в объекте.
//
// Параметры:
//  Объект - ДокументОбъект - прикладной объект, запись которого инициировала вызов метода. Входной параметр.
//  ИзменилисьКлючевыеРеквизиты - Булево - признак изменения данных, влияющих на формирование электронного документа. Выходной параметр.
//                                         Если Истина, то текущая версия электронного документа становится неактуальной. 
//                                         По умолчанию для нового документа Истина, иначе Ложь.
//  СостояниеЭлектронногоДокумента - ПеречислениеСсылка.СостоянияВерсийЭД, ПеречислениеСсылка.СостоянияОбменСБанками - состояние текущей версии электронного документа.
//                                   Входной параметр. Может быть использован для анализа текущего этапа обработки электронного документа. 
//                                   Позволяет описать зависимости заполнения выходных параметров от факта создания, подписания или отправки ЭД контрагенту.
//  ПодлежитОбменуЭД - Булево - признак участия документа в ЭДО. Выходной параметр. По умолчанию Истина.
//                              При установке в Ложь прикладной объект не будет отображаться как требующий создания электронного документа (например, раздел "Создать" в текущих делах ЭДО). 
//                              Если ЭД уже был создан, то он становиться неактуальным.
//  Отказ - Булево - если установить Истина, то владелец электронного документа записан не будет. Выходной параметр. По умолчанию Ложь.
//
// Пример:
//  1. Необходимо сделать существующий ЭД неактуальным, чтобы пользователь создал новый. Для этого:
//   * Присвоить параметру  ИзменилисьКлючевыеРеквизиты значение Истина.
//  2. Необходимо отказать пользователю во внесении изменений в документ, если уже есть существующий ЭД. Для этого:
//   * Проверить параметр СостояниеЭлектронногоДокумента на неравенство значению НеСформирован.
//   * Присвоить параметру  Отказ значение Истина.
//   * (необязательно) Присвоить параметру  ИзменилисьКлючевыеРеквизиты значение Истина. 
//     В этом случае пользователь дополнительно получит сообщение: "Существует электронный документ. Изменение ключевых реквизитов документа запрещено.".
//  3. Необходимо исключить прикладной объект из возможных оснований для ЭД. Например, если известно, что он выставлен в бумажном виде, и ЭД не требуется. 
//     Существующий ЭД сделать неактуальным и не отображать прикладной документ в разделе "Создать" обработки "Текущие дела ЭДО". Для этого:
//   * Присвоить параметру  ПодлежитОбменуЭД значение Ложь.
//
Процедура ПередЗаписьюВладельцаЭлектронногоДокумента(Объект, ИзменилисьКлючевыеРеквизиты, Знач СостояниеЭлектронногоДокумента, ПодлежитОбменуЭД, Отказ) Экспорт
	
КонецПроцедуры

#КонецОбласти

