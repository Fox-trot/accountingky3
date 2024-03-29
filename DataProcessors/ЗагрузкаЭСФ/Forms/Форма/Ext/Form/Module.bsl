﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	УстановитьУсловноеОформление();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_Контрагент" Тогда
		ЗаполнитьТаблицуДокументы();
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьФайл(Команда)
	Оповещение = Новый ОписаниеОповещения("ЗагрузитьДанныеЭСФЗавершение", ЭтотОбъект);
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'XML-документ(*.xml)|*.xml'");
	ПараметрыЗагрузки.Диалог.МножественныйВыбор = Ложь;
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите файл для загрузки'");
	ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТабличныеЧасти(Команда)

	Отказ = Ложь;
	
	// Проверка выбранного файла.
	Если ПутьКФайлу = "" Тогда 
		ТекстСообщения = НСтр("ru = 'Не выбран файл для загрузки.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "ПутьКФайлу",, Отказ);
	Иначе 
	    Файл = Новый Файл(ПутьКФайлу);
		Если НЕ Файл.Существует() Тогда 
			ТекстСообщения = НСтр("ru = 'Файла по указанному пути не существует.'");
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "ПутьКФайлу",, Отказ);
		КонецЕсли;
	КонецЕсли;	
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Адрес = ""
		Или НЕ ЭтоАдресВременногоХранилища(Адрес) Тогда 
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьДанныеЭСФЗавершение", ЭтотОбъект);
		ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
		ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
		ФайловаяСистемаКлиент.ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки, ПутьКФайлу);
	Иначе 
		Объект.ТаблицаДокументы.Очистить();
		Объект.ТаблицаТовары.Очистить();

		ЗагрузитьДанныеЭСФНаСервере();
		ТекстОповещения = НСтр("ru = 'Загрузка'");
		ТекстПояснения = НСтр("ru = 'Загрузка файла завершена'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументы(Команда)
	Если НЕ ПроверитьЗаполнение() Тогда 
		Возврат;
	КонецЕсли;
	
	СоздатьДокументыНаКлиенте();	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКонтрагента(Команда)
	Отказ = Ложь;
	
	СтрокаТабличнойЧастиДокументы = Элементы.ТаблицаДокументы.ТекущиеДанные;
	
	Если СтрокаТабличнойЧастиДокументы = Неопределено Тогда 
		ТекстСообщения = НСтр("ru = 'Не выбрана строка в списке Документы.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ТаблицаДокументы",, Отказ);
	ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаТабличнойЧастиДокументы.ПолеИННКонтрагента) Тогда 
		ТекстСообщения = НСтр("ru = 'Не заполнен ИНН контрагента в списке Документы.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ТаблицаДокументы",, Отказ);
	КонецЕсли;

	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	ПараметрыОткрытия = Новый Структура;

	Если ЗначениеЗаполнено(СтрокаТабличнойЧастиДокументы.Контрагент) Тогда 
		ПараметрыОткрытия.Вставить("Ключ", СтрокаТабличнойЧастиДокументы.Контрагент);
	Иначе 
		ЗначениеЗаполнения = Новый Структура;
		ЗначениеЗаполнения.Вставить("ИНН", СтрокаТабличнойЧастиДокументы.ПолеИННКонтрагента);
		ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначениеЗаполнения);
	КонецЕсли;	
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗаписьСоответствия(Команда)
	
	Отказ = Ложь;
	
	СтрокаТабличнойЧастиДокументы = Элементы.ТаблицаДокументы.ТекущиеДанные;
	
	Если СтрокаТабличнойЧастиДокументы = Неопределено Тогда 
		ТекстСообщения = НСтр("ru = 'Не выбрана строка в списке Документы.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ТаблицаДокументы",, Отказ);
	ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаТабличнойЧастиДокументы.Контрагент) Тогда 
		ТекстСообщения = НСтр("ru = 'Не сопаставлен Контрагент в списке Документы.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ТаблицаДокументы",, Отказ);
	КонецЕсли;

	СтрокаТабличнойЧастиТовары = Элементы.ТаблицаТовары.ТекущиеДанные;
	
	Если СтрокаТабличнойЧастиТовары = Неопределено Тогда 
		ТекстСообщения = НСтр("ru = 'Не выбрана строка в списке Товары (услуги).'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.ТаблицаТовары",, Отказ);
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Контрагент", СтрокаТабличнойЧастиДокументы.Контрагент); 
	СтруктураПараметров.Вставить("НоменклатураНаименованиеПолное", СтрокаТабличнойЧастиТовары.ПолеНоменклатура); 
	ОткрытьЗаписьСоответствияНаКлиенте(СтруктураПараметров);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаДокументы

&НаКлиенте
Процедура ТаблицаДокументыПриАктивизацииСтроки(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ТаблицаДокументы.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.ТаблицаТовары.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ИдентификаторЭСФ", СтрокаТабличнойЧасти.ИдентификаторЭСФ));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура настройки условного оформления форм и динамических списков.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// Полученные значения отображаются серым.
	Элемент = УсловноеОформление.Элементы.Добавить();
	// Таблица Документы.
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДокументыПолеКонтрагент");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДокументыПолеИННКонтрагента");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДокументыПолеНомерДоговораКонтрагента");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДокументыПолеДатаДоговораКонтрагента");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДокументыПолеФормаОплаты");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДокументыПолеСтавкаНДС");
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДокументыПолеСтавкаНСП");
	// Таблица Товары
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаТоварыПолеНоменклатура");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЦвет);
	
	// В таблице Документы заполнена ссылка на ЭСФ.
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДокументы");
	
	// Не пустая ссылка ЭСФ.
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТаблицаДокументы.ДокументЭСФ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Документы.ЭлектронныйСчетФактураПолученный.ПустаяСсылка();

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаЧередованияСтрокиБЭД);

	//// Таблица Документы.
	//Элемент = УсловноеОформление.Элементы.Добавить();

	//ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	//ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаДокументы");

	//ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	//ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	//
	//// Пустой Контрагент.
	//ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТаблицаДокументы.Контрагент");
	//ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//ОтборЭлемента.ПравоеЗначение = Справочники.Контрагенты.ПустаяСсылка();
	//
	//// Пустой Договор контрагента.
	//ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТаблицаДокументы.ДоговорКонтрагента");
	//ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//ОтборЭлемента.ПравоеЗначение = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();

	//Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);

	//// Таблица Товары
	//Элемент = УсловноеОформление.Элементы.Добавить();

	//ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	//ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаТовары");

	//ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	//ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	//
	//// Пустая Номенклатура.
	//ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ТаблицаТовары.Номенклатура");
	//ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//ОтборЭлемента.ПравоеЗначение = Справочники.Номенклатура.ПустаяСсылка();
	//
	//Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьДанныеЭСФЗавершение(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	Объект.ТаблицаДокументы.Очистить();
	Объект.ТаблицаТовары.Очистить();
	
	ПутьКФайлу = ПомещенныйФайл.Имя;
	Адрес = ПомещенныйФайл.Хранение;
	ЗагрузитьДанныеЭСФНаСервере();
	
	ТекстОповещения = НСтр("ru = 'Загрузка'");
	ТекстПояснения = НСтр("ru = 'Загрузка файла завершена'");
	ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеЭСФНаСервере()
	// Получение схемы.
	Реквизиты = РаботаСКонтрагентами.РеквизитыЭлектроннойСФ();
	
	Если ЗначениеЗаполнено(Реквизиты.ОписаниеОшибки) Тогда 
		ВызватьИсключение Реквизиты.ОписаниеОшибки;
	КонецЕсли;
	
	// Чтение переданного на сервер файла.
	ВременныйФайл = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
    ДвоичныеДанные.Записать(ВременныйФайл);
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ВременныйФайл);
	
	ОбъектXDTO = Реквизиты.Прокси.ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
	
	// Обработка файла.
	Если ТипЗнч(ОбъектXDTO.receipt) = Тип("ОбъектXDTO") Тогда 
		ЗаполнитьСтрокуДокументы(ОбъектXDTO.receipt);
	Иначе 
		Для Каждого СтрокаДокумент Из ОбъектXDTO.receipt Цикл
			ЗаполнитьСтрокуДокументы(СтрокаДокумент);
		КонецЦикла;
	КонецЕсли;	
	
	// Заполнение ссылочных полей.
	ЗаполнитьТаблицуДокументы();
	ЗаполнитьТаблицуТовары();
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьСтрокуДокументы(СтрокаДокумент)

		СтрокаТабличнойЧасти = Объект.ТаблицаДокументы.Добавить();
		
		// Структура для заполнения файла.
		ПараметрыШапки = ШаблонПараметровШапки();
		ЗаполнитьЗначенияСвойств(ПараметрыШапки, СтрокаДокумент);
		
		// Вид операции.
		Если ПараметрыШапки.receiptTypeCode = "10" Тогда 
			СтрокаТабличнойЧасти.ВидОперации = Перечисления.ВидыОперацийЭСФ.ПоставкаТоваров;
		ИначеЕсли ПараметрыШапки.receiptTypeCode = "20" Тогда 
			СтрокаТабличнойЧасти.ВидОперации = Перечисления.ВидыОперацийЭСФ.АктОбОказанииУслуг;
		КонецЕсли;	
		
		// Контрагент.
		СтрокаТабличнойЧасти.ПолеКонтрагент = ПараметрыШапки.contractorName;
		СтрокаТабличнойЧасти.ПолеИННКонтрагента = ПараметрыШапки.contractorPin;
		
		// Договор контрагента.
		СтрокаТабличнойЧасти.ПолеНомерДоговораКонтрагента = ПараметрыШапки.deliveryContractNumber;
		СтрокаТабличнойЧасти.ПолеДатаДоговораКонтрагента = ПараметрыШапки.deliveryContractDate;
		
		// Форма оплаты.
		СтрокаТабличнойЧасти.ПолеФормаОплаты = ПараметрыШапки.paymentTypeCode;
		Если ПараметрыШапки.paymentTypeCode = "10" Тогда 
			СтрокаТабличнойЧасти.ФормаОплаты = Перечисления.ФормыОплаты.Наличная;
		ИначеЕсли ПараметрыШапки.paymentTypeCode = "20" Тогда
			СтрокаТабличнойЧасти.ФормаОплаты = Перечисления.ФормыОплаты.Безналичная;
		ИначеЕсли ПараметрыШапки.paymentTypeCode = "30" Тогда
			СтрокаТабличнойЧасти.ФормаОплаты = Перечисления.ФормыОплаты.БезвозмезднаяПоставка;
		КонецЕсли;
		
		// Дата поставки.
		СтрокаТабличнойЧасти.ДатаПоставки = Дата(СтрЗаменить(ПараметрыШапки.createdDate, "-", ""));
			
		// Ставка НДС.
		СтрокаТабличнойЧасти.ПолеСтавкаНДС = ПараметрыШапки.vatCode;
		Если ПараметрыШапки.vatCode = "10" Тогда 
			СтрокаТабличнойЧасти.ЗначениеСтавкиНДС = 12;
		ИначеЕсли ПараметрыШапки.vatCode = "20" Тогда 
			СтрокаТабличнойЧасти.ЗначениеСтавкиНДС = 0;
		ИначеЕсли ПараметрыШапки.vatCode = "90" Тогда 
			СтрокаТабличнойЧасти.ЗначениеСтавкиНДС = 0;
		КонецЕсли;	
		
		// Курс.
		СтрокаТабличнойЧасти.Курс = ПараметрыШапки.exchangeRate;
		
		// Номер ЭСФ.
		СтрокаТабличнойЧасти.НомерЭСФ = ПараметрыШапки.invoiceNumber;
		
		// Идентификатор ЭСФ.
		СтрокаТабличнойЧасти.ИдентификаторЭСФ = ПараметрыШапки.exchangeCode;
		
		// Товары (услуги).
		Если ТипЗнч(ПараметрыШапки.goods.good) = Тип("ОбъектXDTO") Тогда
			ЗаполнитьСтрокуТовары(ПараметрыШапки.goods.good, СтрокаТабличнойЧасти);
		Иначе
			Для Каждого СтрокаТовары Из ПараметрыШапки.goods.good Цикл 
				ЗаполнитьСтрокуТовары(СтрокаТовары, СтрокаТабличнойЧасти);
			КонецЦикла;			
		КонецЕсли;
		
		// Определение вида документа.
		Если ТипЗнч(ПараметрыШапки.correctedReceiptCode) = Тип("Строка")
			И ЗначениеЗаполнено(ПараметрыШапки.correctedReceiptCode) Тогда 
			СтрокаТабличнойЧасти.ВидДокументаУчета = "Возврат";
			
			СтрокаТабличнойЧасти.НомерКорректируемогоЭСФ = ПараметрыШапки.correctedReceiptCode; 
			СтрокаТабличнойЧасти.СерияКорректируемогоСФ = ПараметрыШапки.correctionSeries;
			СведенияОбЭСФ = ЭСФСервер.СведенияОбЭСФНоНомеруЭСФ(Организация, ПараметрыШапки.correctedReceiptCode);  
			СтрокаТабличнойЧасти.ДокументКорректировочныйЭСФ = СведенияОбЭСФ.ДокументСсылка;  
			
		Иначе 
			СтрокаТабличнойЧасти.ВидДокументаУчета = "Поступление";
		КонецЕсли;	

КонецПроцедуры // ЗаполнитьСтрокуДокументы()

&НаСервере
Процедура ЗаполнитьСтрокуТовары(СтрокаТовары, СтрокаТабличнойЧастиДокументы)

	ПараметрыСтроки = ШаблонПараметровСтроки();
	ЗаполнитьЗначенияСвойств(ПараметрыСтроки, СтрокаТовары);
	
	// Ставка НСП.
	СтрокаТабличнойЧастиДокументы.ПолеСтавкаНСП = ПараметрыСтроки.stCode;
	Если ПараметрыСтроки.stCode = "50" Тогда 
		СтрокаТабличнойЧастиДокументы.ЗначениеСтавкиНСП = 0;	
	ИначеЕсли ПараметрыСтроки.stCode = "40" Тогда 
		СтрокаТабличнойЧастиДокументы.ЗначениеСтавкиНСП = 1;	
	ИначеЕсли ПараметрыСтроки.stCode = "30" Тогда 
		СтрокаТабличнойЧастиДокументы.ЗначениеСтавкиНСП = 2;	
	ИначеЕсли ПараметрыСтроки.stCode = "60" Тогда 
		СтрокаТабличнойЧастиДокументы.ЗначениеСтавкиНСП = 3;	
	ИначеЕсли ПараметрыСтроки.stCode = "80" Тогда 
		СтрокаТабличнойЧастиДокументы.ЗначениеСтавкиНСП = 5;	
	КонецЕсли;		
	
	СтрокаТабличнойЧасти = Объект.ТаблицаТовары.Добавить();
	
	// Идентификатор ЭСФ.
	СтрокаТабличнойЧасти.ИдентификаторЭСФ = СтрокаТабличнойЧастиДокументы.ИдентификаторЭСФ;
	
	// Номенклатура
	СтрокаТабличнойЧасти.ПолеНоменклатура = ПараметрыСтроки.goodsName;
	
	// Количество.
	СтрокаТабличнойЧасти.Количество = ПараметрыСтроки.baseCount;
	Если СтрокаТабличнойЧасти.Количество < 0 Тогда 
		СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество * -1;
	КонецЕсли;	
	
	// Цена.
	СтрокаТабличнойЧасти.Цена = ПараметрыСтроки.price;
	Если СтрокаТабличнойЧасти.Цена < 0 Тогда 
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Цена * -1;
	КонецЕсли;	
	
	// Сумма НДС.
	СтрокаТабличнойЧасти.СуммаНДС = ПараметрыСтроки.vatAmount;
	Если СтрокаТабличнойЧасти.СуммаНДС < 0 Тогда 
		СтрокаТабличнойЧасти.СуммаНДС = СтрокаТабличнойЧасти.СуммаНДС * -1;
	КонецЕсли;	

	// Сумма НСП.
	СтрокаТабличнойЧасти.СуммаНСП = ПараметрыСтроки.stAmount;
	Если СтрокаТабличнойЧасти.СуммаНСП < 0 Тогда 
		СтрокаТабличнойЧасти.СуммаНСП = СтрокаТабличнойЧасти.СуммаНСП * -1;
	КонецЕсли;	
	
	СтрокаТабличнойЧасти.Всего = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Всего - СтрокаТабличнойЧасти.СуммаНДС - СтрокаТабличнойЧасти.СуммаНСП;

КонецПроцедуры // ЗаполнитьСтрокуТовары()

// Процедура производит поиск контрагентов по ИНН
// и дозаполняет таблицу Документы
// Процедура производит поиск договоров контрагента по номеру
// и дозаполняет таблицу Документы
// Процедура производит поиск ранее созданного документа ЭСФ по Номеру ЭСФ
// и дозаполняет таблицу Документы 
//
&НаСервере
Процедура ЗаполнитьТаблицуДокументы()

	// 1. Контрагенты.
	// 2. Догоры.
	// 3. Документы ЭСФ и Документы учета (Поступление, Доп.расход, Возврат).
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВременнаяТаблицаДокументы.ПолеИННКонтрагента КАК ИНН,
		|	ВременнаяТаблицаДокументы.ПолеНомерДоговораКонтрагента КАК НомерДоговора,
		|	ВременнаяТаблицаДокументы.НомерЭСФ КАК НомерЭСФ,
		|	ВременнаяТаблицаДокументы.ИдентификаторЭСФ КАК ИдентификаторЭСФ
		|ПОМЕСТИТЬ ВременнаяТаблицаДокументы
		|ИЗ
		|	&ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДокументы.ИдентификаторЭСФ КАК ИдентификаторЭСФ,
		|	Контрагенты.Ссылка КАК Контрагент,
		|	ВременнаяТаблицаДокументы.НомерДоговора КАК НомерДоговора
		|ПОМЕСТИТЬ ВременнаяТаблицаКонтрагенты
		|ИЗ
		|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО ВременнаяТаблицаДокументы.ИНН = Контрагенты.ИНН
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаКонтрагенты.ИдентификаторЭСФ КАК ИдентификаторЭСФ,
		|	ВременнаяТаблицаКонтрагенты.Контрагент КАК Контрагент
		|ИЗ
		|	ВременнаяТаблицаКонтрагенты КАК ВременнаяТаблицаКонтрагенты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаКонтрагенты.ИдентификаторЭСФ КАК ИдентификаторЭСФ,
		|	ЕСТЬNULL(ДоговорыКонтрагентов.Ссылка, ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)) КАК ДоговорКонтрагента,
		|	ВременнаяТаблицаКонтрагенты.Контрагент КАК Контрагент
		|ИЗ
		|	ВременнаяТаблицаКонтрагенты КАК ВременнаяТаблицаКонтрагенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|		ПО ВременнаяТаблицаКонтрагенты.Контрагент = ДоговорыКонтрагентов.Владелец
		|			И ВременнаяТаблицаКонтрагенты.НомерДоговора = ДоговорыКонтрагентов.НомерДоговора
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДокументы.ИдентификаторЭСФ КАК ИдентификаторЭСФ,
		|	СведенияОбЭСФ.Регистратор КАК СсылкаДокументЭСФ,
		|	СведенияОбЭСФ.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОбЭСФ КАК СведенияОбЭСФ
		|		ПО ВременнаяТаблицаДокументы.НомерЭСФ = СведенияОбЭСФ.НомерЭСФ
		|ГДЕ
		|	НЕ СведенияОбЭСФ.НомерЭСФ = """"";
	Запрос.УстановитьПараметр("ВременнаяТаблицаДокументы", Объект.ТаблицаДокументы.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Контрагент.
	ВыборкаДетальныеЗаписи = МассивРезультатов[2].Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ИдентификаторЭСФ", ВыборкаДетальныеЗаписи.ИдентификаторЭСФ);
		НайденныеСтроки = Объект.ТаблицаДокументы.НайтиСтроки(ПараметрыОтбора);	
		Если НайденныеСтроки.Количество() > 0 Тогда 
			НайденныеСтроки[0].Контрагент = ВыборкаДетальныеЗаписи.Контрагент;
		КонецЕсли;	
	КонецЦикла;
	
	// Договор.
	ВыборкаДетальныеЗаписи = МассивРезультатов[3].Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ИдентификаторЭСФ", ВыборкаДетальныеЗаписи.ИдентификаторЭСФ);
		НайденныеСтроки = Объект.ТаблицаДокументы.НайтиСтроки(ПараметрыОтбора);	
		Если НайденныеСтроки.Количество() > 0 Тогда 
			Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ДоговорКонтрагента) Тогда 
				ДоговорКонтрагента = ВыборкаДетальныеЗаписи.ДоговорКонтрагента;
			Иначе 	
				// Если нет договора с таким номером- устанавливаем основной с поставщиком.
				ДоговорКонтрагента = ПолучитьДоговорПоУмолчанию(ВыборкаДетальныеЗаписи.Контрагент, Организация);  
			КонецЕсли;	
			
			НайденныеСтроки[0].ДоговорКонтрагента = ДоговорКонтрагента;
		КонецЕсли;	
	КонецЦикла;
	
	// Документ ЭСФ и учета.
	ВыборкаДетальныеЗаписи = МассивРезультатов[4].Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ИдентификаторЭСФ", ВыборкаДетальныеЗаписи.ИдентификаторЭСФ);
		НайденныеСтроки = Объект.ТаблицаДокументы.НайтиСтроки(ПараметрыОтбора);	
		Если НайденныеСтроки.Количество() > 0 Тогда 
			НайденныеСтроки[0].ДокументЭСФ = ВыборкаДетальныеЗаписи.СсылкаДокументЭСФ;
			НайденныеСтроки[0].ДокументУчета = ВыборкаДетальныеЗаписи.ДокументОснование;
			// Переопределение вида документа учета.
			Если ТипЗнч(ВыборкаДетальныеЗаписи.ДокументОснование) = Тип("ДокументСсылка.ВозвратТоваровПоставщику") Тогда 
				НайденныеСтроки[0].ВидДокументаУчета = "Возврат";
			ИначеЕсли ТипЗнч(ВыборкаДетальныеЗаписи.ДокументОснование) = Тип("ДокументСсылка.ДополнительныеРасходы") Тогда
				НайденныеСтроки[0].ВидДокументаУчета = "ДопРасход";
			ИначеЕсли ТипЗнч(ВыборкаДетальныеЗаписи.ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда
				НайденныеСтроки[0].ВидДокументаУчета = "Поступление";
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;
	
	// Заполнение индекса картинки.
	Для Каждого СтрокаТабличнойЧасти Из Объект.ТаблицаДокументы Цикл 
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Контрагент)
			Или НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДоговорКонтрагента) Тогда 
			СтрокаТабличнойЧасти.ИндексКартинки = 1;
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры // ЗаполнитьТаблицуДокументы()

// Процедура производит поиск Номерклатуры в регистра сведений соответствия по наименованию
// и дозаполняет таблицу Товары 
// Процедура производит поиск Номерклатуры по Полному наименованию
// и дозаполняет таблицу Товары
//
&НаСервере
Процедура ЗаполнитьТаблицуТовары()

	// 1. Поиск по соответствию.
	// 2. Поиск по полному наименованию.
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВременнаяТаблицаДокументы.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаДокументы.ИдентификаторЭСФ КАК ИдентификаторЭСФ
		|ПОМЕСТИТЬ ВременнаяТаблицаДокументы
		|ИЗ
		|	&ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ИдентификаторЭСФ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаТовары.ПолеНоменклатура КАК НаименованиеПолное,
		|	ВременнаяТаблицаТовары.ИдентификаторЭСФ КАК ИдентификаторЭСФ
		|ПОМЕСТИТЬ ВременнаяТаблицаТовары
		|ИЗ
		|	&ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ИдентификаторЭСФ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДокументы.Контрагент КАК Контрагент,
		|	ВременнаяТаблицаДокументы.ИдентификаторЭСФ КАК ИдентификаторЭСФ,
		|	ВременнаяТаблицаТовары.НаименованиеПолное КАК НаименованиеПолное
		|ПОМЕСТИТЬ ВременнаяТаблицаДокументыТовары
		|ИЗ
		|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаТовары КАК ВременнаяТаблицаТовары
		|		ПО ВременнаяТаблицаДокументы.ИдентификаторЭСФ = ВременнаяТаблицаТовары.ИдентификаторЭСФ
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	НаименованиеПолное,
		|	Контрагент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДокументыТовары.ИдентификаторЭСФ КАК ИдентификаторЭСФ,
		|	ВременнаяТаблицаДокументыТовары.НаименованиеПолное КАК НаименованиеПолное,
		|	СоответствияНоменклатурыЭСФ.Номенклатура КАК Номенклатура
		|ИЗ
		|	ВременнаяТаблицаДокументыТовары КАК ВременнаяТаблицаДокументыТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствияНоменклатурыЭСФ КАК СоответствияНоменклатурыЭСФ
		|		ПО ВременнаяТаблицаДокументыТовары.Контрагент = СоответствияНоменклатурыЭСФ.Контрагент
		|			И ВременнаяТаблицаДокументыТовары.НаименованиеПолное = СоответствияНоменклатурыЭСФ.НоменклатураНаименованиеПолное
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаДокументыТовары.ИдентификаторЭСФ КАК ИдентификаторЭСФ,
		|	ВременнаяТаблицаДокументыТовары.НаименованиеПолное КАК НаименованиеПолное,
		|	Номенклатура.Ссылка КАК Номенклатура
		|ИЗ
		|	ВременнаяТаблицаДокументыТовары КАК ВременнаяТаблицаДокументыТовары
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
		|		ПО ВременнаяТаблицаДокументыТовары.НаименованиеПолное = Номенклатура.НаименованиеПолное";
	Запрос.УстановитьПараметр("ВременнаяТаблицаДокументы", Объект.ТаблицаДокументы.Выгрузить());
	Запрос.УстановитьПараметр("ВременнаяТаблицаТовары", Объект.ТаблицаТовары.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// По соответствию.
	ВыборкаДетальныеЗаписи = МассивРезультатов[3].Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ИдентификаторЭСФ", ВыборкаДетальныеЗаписи.ИдентификаторЭСФ);
		ПараметрыОтбора.Вставить("ПолеНоменклатура", ВыборкаДетальныеЗаписи.НаименованиеПолное);
		НайденныеСтроки = Объект.ТаблицаТовары.НайтиСтроки(ПараметрыОтбора);	
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл 
			НайденнаяСтрока.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		КонецЦикла;	
	КонецЦикла;
	
	// По полному наименованию.
	ВыборкаДетальныеЗаписи = МассивРезультатов[4].Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("ИдентификаторЭСФ", ВыборкаДетальныеЗаписи.ИдентификаторЭСФ);
		ПараметрыОтбора.Вставить("ПолеНоменклатура", ВыборкаДетальныеЗаписи.НаименованиеПолное);
		НайденныеСтроки = Объект.ТаблицаТовары.НайтиСтроки(ПараметрыОтбора);	
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл 
			Если НЕ ЗначениеЗаполнено(НайденнаяСтрока.Номенклатура) Тогда 
				НайденнаяСтрока.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
			КонецЕсли;	
		КонецЦикла;	
	КонецЦикла;
	
	// Заполнение индекса картинки.
	Для Каждого СтрокаТабличнойЧасти Из Объект.ТаблицаТовары Цикл 
		Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Номенклатура) Тогда 
			СтрокаТабличнойЧасти.ИндексКартинки = 1;
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры // ЗаполнитьТаблицуТовары()

&НаСервереБезКонтекста
Функция ПолучитьДоговорПоУмолчанию(Контрагент, Организация)
	
	СписокВидовДоговоров = Новый СписокЗначений;
	СписокВидовДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
	
	ДоговорПоУмолчанию = Справочники.ДоговорыКонтрагентов.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
	
	Возврат ДоговорПоУмолчанию;
	
КонецФункции

// Функция - Шаблон параметров шапки
// 
// Возвращаемое значение:
//   Параметры - Структура
//
&НаСервере
Функция ШаблонПараметровШапки()
	ПараметрыШапки = Новый Структура;
	ПараметрыШапки.Вставить("receiptTypeCode", "");
	ПараметрыШапки.Вставить("contractorName", "");
	ПараметрыШапки.Вставить("contractorPin", "");
	ПараметрыШапки.Вставить("deliveryContractNumber", "");
	ПараметрыШапки.Вставить("deliveryContractDate", "");
	ПараметрыШапки.Вставить("paymentTypeCode", "");
	ПараметрыШапки.Вставить("createdDate", "");
	ПараметрыШапки.Вставить("vatCode", "");
	ПараметрыШапки.Вставить("exchangeRate", "");
	ПараметрыШапки.Вставить("invoiceNumber", "");
	ПараметрыШапки.Вставить("exchangeCode", "");
	ПараметрыШапки.Вставить("correctedReceiptCode", "");
	ПараметрыШапки.Вставить("correctionSeries", "");
	ПараметрыШапки.Вставить("goods", Неопределено);

	Возврат ПараметрыШапки;	
КонецФункции // ШаблонПараметровШапки()

// Функция - Шаблон параметров строки
// 
// Возвращаемое значение:
//   Параметры - Структура
//
&НаСервере
Функция ШаблонПараметровСтроки()
	ПараметрыСтроки = Новый Структура;
	ПараметрыСтроки.Вставить("goodsName", "");
	ПараметрыСтроки.Вставить("baseCount", "");
	ПараметрыСтроки.Вставить("price", "");
	ПараметрыСтроки.Вставить("vatAmount", "");
	ПараметрыСтроки.Вставить("stCode", "");
	ПараметрыСтроки.Вставить("stAmount", "");

	Возврат ПараметрыСтроки;	
КонецФункции // ШаблонПараметровШапки()

// Процедура - Добавить соответствие на клиенте
//
// Параметры:
//  СтруктураПараметров	 - Структура	 - Парамтры отбора для открытия формы по ключу записи.
//
&НаКлиенте
Процедура ОткрытьЗаписьСоответствияНаКлиенте(СтруктураПараметров)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьТаблицаТоварыПослеИзмененияСоответствия", ЭтотОбъект, СтруктураПараметров);
	
	КлючЗаписи = ПолучитьКлючЗаписи(СтруктураПараметров);
	
	Если КлючЗаписи.ЗаписьСуществует Тогда
		// Открыть существующую запись.
		КлючЗаписи.Удалить("ЗаписьСуществует");
		
		ПараметрыМассив = Новый Массив;
		ПараметрыМассив.Добавить(КлючЗаписи);
		
		КлючЗаписиРегистра = Новый("РегистрСведенийКлючЗаписи.СоответствияНоменклатурыЭСФ", ПараметрыМассив);
		ОткрытьФорму("РегистрСведений.СоответствияНоменклатурыЭСФ.ФормаЗаписи", Новый Структура("Ключ", КлючЗаписиРегистра), ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		// Открыть новую запись.
		ОткрытьФорму("РегистрСведений.СоответствияНоменклатурыЭСФ.ФормаЗаписи", Новый Структура("ЗначенияЗаполнения", СтруктураПараметров), ЭтаФорма,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицаТоварыПослеИзмененияСоответствия(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	ОбновитьТаблицаТоварыПослеИзмененияСоответствияНаСервере(ДополнительныеПараметры);
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицаТоварыПослеИзмененияСоответствияНаСервере(СтруктураПараметров)
	
	// Заполнение номенклатуры по всем строкам Контрагента.
	СоответствиеНоменклатуры = РегистрыСведений.СоответствияНоменклатурыЭСФ.ПолучитьСоответствиеНоменклатуры(СтруктураПараметров);
	
	Если ЗначениеЗаполнено(СоответствиеНоменклатуры.Номенклатура) Тогда 
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Контрагент", СтруктураПараметров.Контрагент);
		НайденныеСтрокиДокументы = Объект.ТаблицаДокументы.НайтиСтроки(ПараметрыОтбора);	
		Для Каждого НайденнаяСтрокаДокумент Из НайденныеСтрокиДокументы Цикл 
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("ИдентификаторЭСФ", НайденнаяСтрокаДокумент.ИдентификаторЭСФ);
			ПараметрыОтбора.Вставить("ПолеНоменклатура", СтруктураПараметров.НоменклатураНаименованиеПолное);
			НайденныеСтрокиТовары = Объект.ТаблицаТовары.НайтиСтроки(ПараметрыОтбора);	
			Для Каждого НайденнаяСтрокаТовары Из НайденныеСтрокиТовары Цикл 
				НайденнаяСтрокаТовары.Номенклатура = СоответствиеНоменклатуры.Номенклатура;
				НайденнаяСтрокаТовары.ИндексКартинки = 0;
			КонецЦикла;	
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры // ОбновитьТаблицаТоварыПослеИзмененияСоответствияНаСервере()

// Функция возвращает ключ записи регистра.
//
&НаСервереБезКонтекста
Функция ПолучитьКлючЗаписи(СтруктураПараметров)
	Возврат РегистрыСведений.СоответствияНоменклатурыЭСФ.ПолучитьКлючЗаписи(СтруктураПараметров);
КонецФункции // ПолучитьКлючЗаписи()

// Процедура создает новые документы или перезаполняет существу.щие и записывает их.
//
&НаКлиенте
Процедура СоздатьДокументыНаКлиенте()

	Прогресс = 0;
	Шаг = 100 / Объект.ТаблицаДокументы.Количество();
	Для Каждого СтрокаТабличнойЧасти Из Объект.ТаблицаДокументы Цикл
		Состояние(НСтр("ru = 'Обработка ЭСФ'"), Прогресс, СтрШаблон("%1 %2", СтрокаТабличнойЧасти.Контрагент, СтрокаТабличнойЧасти.НомерЭСФ));
		
		//Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДокументУчета)
		//	И ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДокументЭСФ) Тогда 
		//	Продолжить;
		//КонецЕсли;	
		
		СоздатьДокументыНаСервере(СтрокаТабличнойЧасти.НомерСтроки);		
		
		Прогресс = Прогресс + Шаг; 
	КонецЦикла;
	Состояние(НСтр("ru = 'Обработка ЭСФ'"), Прогресс);
	
	ТекстОповещения = НСтр("ru = 'Обработка ЭСФ'");
	ТекстПояснения = НСтр("ru = 'Файл загружен'");
	ПоказатьОповещениеПользователя(
		ТекстОповещения,
		, 
		ТекстПояснения, 
		БиблиотекаКартинок.Успешно32);

КонецПроцедуры // СоздатьДокументыНАКлиенте()

// Процедура - создать документы учета и эсф
//
// Параметры:
//  СтрокаТабличнойЧастиДокументы	 - СтрокаТабличнойЧасти	 - Данные строки табличной части Документы
//
&НаСервере
Процедура СоздатьДокументыНаСервере(НомерСтрокиТабличнойЧасти)

	СтрокаТабличнойЧастиДокументы = Объект.ТаблицаДокументы[НомерСтрокиТабличнойЧасти-1];
	
	НачатьТранзакцию();
	
	Попытка
		
		// Создание документа учета.
		Если СтрокаТабличнойЧастиДокументы.ВидДокументаУчета = "Поступление" Тогда
			ДокументУчетаСсылка = СоздатьДокументПоступлениеТоваровУслуг(СтрокаТабличнойЧастиДокументы);
		ИначеЕсли СтрокаТабличнойЧастиДокументы.ВидДокументаУчета = "ДопРасход" Тогда  
			ДокументУчетаСсылка = СоздатьДокументДополнительныеРасходы(СтрокаТабличнойЧастиДокументы);
		ИначеЕсли СтрокаТабличнойЧастиДокументы.ВидДокументаУчета = "Возврат" Тогда  
			ДокументУчетаСсылка = СоздатьДокументВозвратТоваровПоставщику(СтрокаТабличнойЧастиДокументы);
		КонецЕсли;	
		
		// Создание документа ЭСФ.
		Если ЗначениеЗаполнено(СтрокаТабличнойЧастиДокументы.ДокументЭСФ) Тогда 
			ДокументОбъект = СтрокаТабличнойЧастиДокументы.ДокументЭСФ.ПолучитьОбъект();
			ДокументЭСФСсылка = СтрокаТабличнойЧастиДокументы.ДокументЭСФ;
		Иначе 
			ДокументОбъект = Документы.ЭлектронныйСчетФактураПолученный.СоздатьДокумент();
			ДокументЭСФСсылка = Документы.ЭлектронныйСчетФактураПолученный.ПолучитьСсылку();
			ДокументОбъект.УстановитьСсылкуНового(ДокументЭСФСсылка);
			ДокументОбъект.Дата = ТекущаяДатаСеанса();
		КонецЕсли;	
		
		ДокументОбъект.Заполнить(ДокументУчетаСсылка);
		
		ЗаполнитьЗначенияСвойств(ДокументОбъект, СтрокаТабличнойЧастиДокументы); 
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, Истина, Истина, РежимЗаписиДокумента.Проведение);
		
		СтрокаТабличнойЧастиДокументы.ДокументЭСФ = ДокументЭСФСсылка;		
		СтрокаТабличнойЧастиДокументы.ДокументУчета = ДокументУчетаСсылка;		
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		
		ТекстСообщения = НСтр("ru='Не удалось завершить создание документа.
			|Техническая информация об ошибке: %1'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));	
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить создание документа по причине: %1'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
	КонецПопытки;

КонецПроцедуры // СоздатьДокументыНаСервере()

Функция СоздатьДокументПоступлениеТоваровУслуг(СтрокаТабличнойЧастиДокументы)
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧастиДокументы.ДокументУчета) Тогда 
		ДокументОбъект = СтрокаТабличнойЧастиДокументы.ДокументУчета.ПолучитьОбъект();
	Иначе 	
		ДокументОбъект = Документы.ПоступлениеТоваровУслуг.СоздатьДокумент();
		ДокументОбъект.Дата = ТекущаяДатаСеанса();
		ДокументОбъект.Комментарий = СтрШаблон(НСтр("ru = 'Автоматическое создание документа. %1'"), ТекущаяДатаСеанса());
		ДокументОбъект.Организация = Организация;
	КонецЕсли;	
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИдентификаторЭСФ", СтрокаТабличнойЧастиДокументы.ИдентификаторЭСФ);
	НайденныеСтроки = Объект.ТаблицаТовары.НайтиСтроки(ПараметрыОтбора);	
	
	ДокументОбъект.Заполнить(Неопределено);
	ДокументОбъект.ЗаполнитьПоЭлектронныйСчетФактураПолученныйЗаугрузка(СтрокаТабличнойЧастиДокументы, НайденныеСтроки);
	
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, Истина, Истина, РежимЗаписиДокумента.Запись);
	
	Возврат ДокументОбъект.Ссылка;

КонецФункции

Функция СоздатьДокументВозвратТоваровПоставщику(СтрокаТабличнойЧастиДокументы)
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧастиДокументы.ДокументУчета) Тогда 
		ДокументОбъект = СтрокаТабличнойЧастиДокументы.ДокументУчета.ПолучитьОбъект();
	Иначе 	
		ДокументОбъект = Документы.ВозвратТоваровПоставщику.СоздатьДокумент();
		ДокументОбъект.Дата = ТекущаяДатаСеанса();
		ДокументОбъект.Комментарий = СтрШаблон(НСтр("ru = 'Автоматическое создание документа. %1'"), ТекущаяДатаСеанса());
		ДокументОбъект.Организация = Организация;
	КонецЕсли;	
		
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИдентификаторЭСФ", СтрокаТабличнойЧастиДокументы.ИдентификаторЭСФ);
	НайденныеСтроки = Объект.ТаблицаТовары.НайтиСтроки(ПараметрыОтбора);	
	
	ДокументОбъект.Заполнить(Неопределено);
	ДокументОбъект.ЗаполнитьПоЭлектронныйСчетФактураПолученныйЗаугрузка(СтрокаТабличнойЧастиДокументы, НайденныеСтроки);
	
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, Истина, Истина, РежимЗаписиДокумента.Запись);
	
	Возврат ДокументОбъект.Ссылка;

КонецФункции

Функция СоздатьДокументДополнительныеРасходы(СтрокаТабличнойЧастиДокументы)
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧастиДокументы.ДокументУчета) Тогда 
		ДокументОбъект = СтрокаТабличнойЧастиДокументы.ДокументУчета.ПолучитьОбъект();
	Иначе 	
		ДокументОбъект = Документы.ДополнительныеРасходы.СоздатьДокумент();
		ДокументОбъект.Дата = ТекущаяДатаСеанса();
		ДокументОбъект.Комментарий = СтрШаблон(НСтр("ru = 'Автоматическое создание документа. %1'"), ТекущаяДатаСеанса());
		ДокументОбъект.Организация = Организация;
	КонецЕсли;	
		
	ДокументОбъект.Заполнить(Неопределено);
	ЗаполнитьЗначенияСвойств(ДокументОбъект, СтрокаТабличнойЧастиДокументы); 
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ИдентификаторЭСФ", СтрокаТабличнойЧастиДокументы.ИдентификаторЭСФ);
	НайденныеСтроки = Объект.ТаблицаТовары.НайтиСтроки(ПараметрыОтбора);	
	Если НЕ НайденныеСтроки.Количество() = 0 Тогда
		ЗаполнитьЗначенияСвойств(ДокументОбъект, НайденныеСтроки[0]);
		ДокументОбъект.НоменклатураРасходов = НайденныеСтроки[0].Номенклатура;
		ДокументОбъект.СуммаДопРасходов = НайденныеСтроки[0].Всего;
	КонецЕсли;	
	
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, Истина, Истина, РежимЗаписиДокумента.Запись);
	
	Возврат ДокументОбъект.Ссылка;

КонецФункции

#КонецОбласти

