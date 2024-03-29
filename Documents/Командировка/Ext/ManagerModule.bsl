﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Формирует и возвращает текст запроса для выборки данных,
// необходимых для формирования печатной формы
//
Функция ПолучитьТекстЗапросаДляФормированияПечатнойФормыКомандировка()
	
	ТекСтрокаТаблицыЗначенийапроса =
	"ВЫБРАТЬ
	|	Командировка.Ссылка,
	|	Командировка.Номер,
	|	Командировка.Дата,
	|	Командировка.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
	|	Командировка.СуммаДокумента,
	|	Командировка.Страна.Наименование КАК Страна,
	|	Командировка.Город,
	|	Командировка.ДатаНачала,
	|	Командировка.ДатаОкончания,
	|	Командировка.СодержаниеОВыплате,
	|	Командировка.Организация.КодПоОКПО КАК КодПоОКПО,
	|	Командировка.Организация,
	|	Командировка.КоличествоДней
	|ИЗ
	|	Документ.Командировка КАК Командировка
	|ГДЕ
	|	Командировка.Ссылка В(&МассивОбъектов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КомандировкаСотрудники.Ссылка КАК Ссылка,
	|	КомандировкаСотрудники.НомерСтроки КАК НомерСтроки,
	|	КомандировкаСотрудники.ФизЛицо КАК ФизЛицо,
	|	КомандировкаСотрудники.Подразделение.Наименование КАК Подразделение,
	|	КомандировкаСотрудники.Должность.Наименование КАК Должность,
	|	КомандировкаСотрудники.Суточные,
	|	КомандировкаСотрудники.Проживание,
	|	КомандировкаСотрудники.Проездные,
	|	КомандировкаСотрудники.Валюта,
	|	КомандировкаСотрудники.Задание,
	|	КомандировкаСотрудники.СуммаВсего,
	|	КомандировкаСотрудники.ФизЛицо.Код КАК ТабНомер,
	|	КомандировкаСотрудники.ФизЛицо.Наименование КАК ФИО
	|ИЗ
	|	Документ.Командировка.Сотрудники КАК КомандировкаСотрудники
	|ГДЕ
	|	КомандировкаСотрудники.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КомандировкаСотрудники.Ссылка КАК Ссылка,
	|	КомандировкаСотрудники.НомерСтроки КАК НомерСтроки,
	|	КомандировкаСотрудники.ФизЛицо КАК ФизЛицо,
	|	КомандировкаСотрудники.Подразделение.Наименование КАК Подразделение,
	|	КомандировкаСотрудники.Должность.Наименование КАК Должность,
	|	КомандировкаСотрудники.Суточные,
	|	КомандировкаСотрудники.Проживание,
	|	КомандировкаСотрудники.Проездные,
	|	КомандировкаСотрудники.Валюта,
	|	КомандировкаСотрудники.СуммаВсего,
	|	КомандировкаСотрудники.ФизЛицо.Код КАК ТабНомер,
	|	КомандировкаСотрудники.ФизЛицо.Наименование КАК ФИО,
	|	Командировка.ВерсияДанных,
	|	Командировка.ПометкаУдаления,
	|	Командировка.Номер КАК Номер,
	|	Командировка.Дата КАК Дата,
	|	Командировка.Проведен,
	|	Командировка.Организация КАК Организация,
	|	Командировка.Комментарий КАК Комментарий,
	|	Командировка.Автор,
	|	Командировка.СуммаДокумента,
	|	Командировка.Страна.Наименование КАК Страна,
	|	Командировка.ДатаНачала КАК ДатаНачала,
	|	Командировка.ДатаОкончания КАК ДатаОкончания,
	|	Командировка.КоличествоДней,
	|	Командировка.СодержаниеОВыплате КАК СодержаниеОВыплате,
	|	Командировка.Город КАК ГородДокумента,
	|	Командировка.Страна КАК СтранаДокумента
	|ИЗ
	|	Документ.Командировка.Сотрудники КАК КомандировкаСотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Командировка КАК Командировка
	|		ПО КомандировкаСотрудники.Ссылка = Командировка.Ссылка
	|ГДЕ
	|	КомандировкаСотрудники.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ
	|	МАКСИМУМ(НомерСтроки),
	|	МАКСИМУМ(ФизЛицо),
	|	МАКСИМУМ(Должность),
	|	МАКСИМУМ(ТабНомер),
	|	МАКСИМУМ(Номер),
	|	МАКСИМУМ(Дата),
	|	МАКСИМУМ(Организация),
	|	МАКСИМУМ(Комментарий),
	|	МАКСИМУМ(Страна),
	|	МАКСИМУМ(ДатаНачала),
	|	МАКСИМУМ(ДатаОкончания),
	|	МАКСИМУМ(СодержаниеОВыплате),
	|	МАКСИМУМ(ГородДокумента),
	|	МАКСИМУМ(СтранаДокумента)
	|ПО
	|	Ссылка,
	|	Город,
	|	Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасходныйКассовыйОрдер.Ссылка,
	|	РасходныйКассовыйОрдер.Номер КАК НомерРКО,
	|	РасходныйКассовыйОрдер.СуммаДокумента КАК Сумма
	|ИЗ
	|	Документ.РасходныйКассовыйОрдер КАК РасходныйКассовыйОрдер
	|ГДЕ
	|	РасходныйКассовыйОрдер.ДокументОснование В(&МассивОбъектов)";
	
	Возврат ТекСтрокаТаблицыЗначенийапроса;
	
КонецФункции

// Функция формирует табличный документ с печатной формой ПриказКомандировка
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьПриказаКомандировка(МассивОбъектов, ОбъектыПечати)
	Перем Ошибки;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "Командировка_ПриказКомандировка";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Командировка.ПФ_MXL_ПриказКомандировка");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = ПолучитьТекстЗапросаДляФормированияПечатнойФормыКомандировка();
	
	РезультатЗапроса 			= Запрос.ВыполнитьПакет();
	Шапка 						= РезультатЗапроса[0].Выбрать();
	ВременнаяТаблицаСотрудники 	= РезультатЗапроса[1].Выгрузить();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.Следующий()  Цикл
		
		// Выводим из таблицы: один сотрудник - одна страница		
		Отбор = Новый Структура;
		Отбор.Вставить("Ссылка", Шапка.Ссылка);
		МассивСтрок = ВременнаяТаблицаСотрудники.НайтиСтроки(Отбор);
		
		Для каждого СтрокаТаблицыЗначений Из МассивСтрок Цикл
		
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			ПервыйДокумент = Ложь;

			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

			ДанныеПечати = Новый Структура();
			ДанныеПечати.Вставить("НомерДокумента", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер));
			ДанныеПечати.Вставить("ДатаДокумента", Формат(Шапка.Дата,"ДЛФ=D"));
			ДанныеПечати.Вставить("ТабельныйНомер", ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(СтрокаТаблицыЗначений.ТабНомер));
			ДанныеПечати.Вставить("МестоНазначения", Шапка.Страна + ?(ЗначениеЗаполнено(Шапка.Город), ", " + Шапка.Город, ""));
			ДанныеПечати.Вставить("Дни", Шапка.КоличествоДней);
			ДанныеПечати.Вставить("ДатаНачала", Формат(Шапка.ДатаНачала,"ДЛФ=DD"));
			ДанныеПечати.Вставить("ДатаОкончания", Формат(Шапка.ДатаОкончания,"ДЛФ=DD"));
			ДанныеПечати.Вставить("СодержаниеОВыплате", Шапка.СодержаниеОВыплате);
					
			Структура = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизацийРуководители(Шапка.Организация, Шапка.Дата);
			Если НЕ Структура.Свойство("Руководитель") = Неопределено Тогда
				ДанныеПечати.Вставить("ДолжностьРуководителя", 	Структура.РуководительДолжность);
				ДанныеПечати.Вставить("ФИОРуководителя", 		Структура.Руководитель);		
			КонецЕсли;
			
			ОбластьМакета = Макет.ПолучитьОбласть("Шапка");		
			ОбластьМакета.Параметры.Заполнить(Шапка);
			ОбластьМакета.Параметры.Заполнить(СтрокаТаблицыЗначений);
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// В табличном документе зададим имя области, в которую был 
			// выведен объект. Нужно для возможности печати покомплектно.
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);												   
		КонецЦикла;		
	КонецЦикла;
		
	Если НЕ Ошибки = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;	
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Функция формирует табличный документ с печатной формой КомандировочноеУдостоверение
//
// Возвращаемое значение:
//  Табличный документ - печатная форма
//
Функция ПечатьКомандировочногоУдостоверения(МассивОбъектов, ОбъектыПечати)

	Перем Ошибки;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати 	= "Командировка_КомандировочноеУдостоверение";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Командировка.ПФ_MXL_КомандировочноеУдостоверение");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = ПолучитьТекстЗапросаДляФормированияПечатнойФормыКомандировка();
	
	РезультатЗапроса 	= Запрос.ВыполнитьПакет();
	Шапка 				= РезультатЗапроса[0].Выбрать();
	ВременнаяТаблицаСотрудники 	= РезультатЗапроса[1].Выгрузить();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.Следующий()  Цикл
		
		// Выводим из таблицы: один сотрудник - одна страница		
		Отбор = Новый Структура;
		Отбор.Вставить("Ссылка", Шапка.Ссылка);
		МассивСтрок = ВременнаяТаблицаСотрудники.НайтиСтроки(Отбор);
		
		Для каждого СтрокаТаблицыЗначений Из МассивСтрок Цикл
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			ПервыйДокумент = Ложь;
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			ДанныеФизЛица = БухгалтерскийУчетСервер.ПолучитьСведенияОФизЛице(Шапка.Организация, СтрокаТаблицыЗначений.ФизЛицо, Шапка.Дата); 
			
			ДанныеПечати = Новый Структура();
			ДанныеПечати.Вставить("НомерДокумента", 	ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер));
			ДанныеПечати.Вставить("ДатаДокумента", 		Формат(Шапка.Дата,"ДЛФ=D"));
			ДанныеПечати.Вставить("ТабельныйНомер", 	ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(СтрокаТаблицыЗначений.ТабНомер));
			ДанныеПечати.Вставить("МестоНазначения", 	Шапка.Страна + ?(ЗначениеЗаполнено(Шапка.Город), ", " + Шапка.Город, ""));
			ДанныеПечати.Вставить("ДатаНачала", 		Формат(Шапка.ДатаНачала,"ДЛФ=DD"));
			ДанныеПечати.Вставить("ДатаОкончания", 		Формат(Шапка.ДатаОкончания,"ДЛФ=DD"));
			ДанныеПечати.Вставить("СодержаниеОВыплате", Шапка.СодержаниеОВыплате);
			ДанныеПечати.Вставить("Дни", 				Шапка.КоличествоДней);
			ДанныеПечати.Вставить("ДанныеПаспорта", 	СтрШаблон(НСтр("ru = 'Паспорт гражданина Кыргызской Республики %1%2%3%4'"),
											?(ДанныеФизЛица.ПаспортСерия <> "", ", " + ДанныеФизЛица.ПаспортСерия, ""), 
											?(ДанныеФизЛица.ПаспортНомер <> "", ", " + ДанныеФизЛица.ПаспортНомер, ""), 
											?(Формат(ДанныеФизЛица.ПаспортДатаВыдачи, "ДЛФ=D") <> "", ", " + Формат(ДанныеФизЛица.ПаспортДатаВыдачи, "ДЛФ=D"), ""), 
											?(ДанныеФизЛица.ПаспортКемВыдан <> "", ", " + ДанныеФизЛица.ПаспортКемВыдан, "")));
			
			Структура = БухгалтерскийУчетСервер.ОтветственныеЛицаОрганизацийРуководители(Шапка.Организация, Шапка.Дата);
			Если НЕ Структура.Свойство("Руководитель") = Неопределено Тогда
				ДанныеПечати.Вставить("ДолжностьРуководителя", 	Структура.РуководительДолжность);
				ДанныеПечати.Вставить("ФИОРуководителя", 		Структура.Руководитель);	
			КонецЕсли;
			
			ОбластьМакета = Макет.ПолучитьОбласть("ОбластьУдостоверение");
			ОбластьМакета.Параметры.Заполнить(СтрокаТаблицыЗначений);
			ОбластьМакета.Параметры.Заполнить(Шапка);
			ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
		КонецЦикла;
		
	КонецЦикла;
		
	Если НЕ Ошибки = Неопределено Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	КонецЕсли;	
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Устанавливаем признак доступности печати покомплектно.
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	// Проверяем, нужно ли для макета Командировка формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Командировка_Приказ") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Командировка_Приказ", НСтр("ru = 'Печать приказа'"), ПечатьПриказаКомандировка(МассивОбъектов, ОбъектыПечати),,
			"Документ.Командировка.ПФ_MXL_ПриказКомандировка");
		КонецЕсли;
				 
	// Проверяем, нужно ли для макета Командировка формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Командировка_КомандировочноеУдостоверение") Тогда
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
			"Командировка_КомандировочноеУдостоверение", НСтр("ru = 'Командировочное удостоверение'"), ПечатьКомандировочногоУдостоверения(МассивОбъектов, ОбъектыПечати),,
			"Документ.Командировка.ПФ_MXL_КомандировочноеУдостоверение");
		КонецЕсли;	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Командировка_Приказ";
	КомандаПечати.Представление = НСтр("ru = 'Печать приказа'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 1;	
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Командировка_КомандировочноеУдостоверение";
	КомандаПечати.Представление = НСтр("ru = 'Командировочное удостоверение'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок = 10;

	// Комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = 	"Командировка_Приказ,Командировка_КомандировочноеУдостоверение";
	КомандаПечати.Представление = НСтр("ru = 'Комплект документов'");
	КомандаПечати.Картинка = БиблиотекаКартинок.Печать;
	КомандаПечати.ФиксированныйКомплект = Истина;
	КомандаПечати.ПереопределитьПользовательскиеНастройкиКоличества = Истина;
	КомандаПечати.Порядок = 75;
	
	// Настраиваемый комплект документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = 	"Командировка_Приказ,Командировка_КомандировочноеУдостоверение";
	КомандаПечати.Представление = НСтр("ru = 'Настраиваемый комплект документов'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ПечатьСразу;
	КомандаПечати.ЗаголовокФормы = НСтр("ru = 'Настраиваемый комплект'");
	КомандаПечати.ДополнитьКомплектВнешнимиПечатнымиФормами = Истина;
	КомандаПечати.Порядок = 79;	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
