﻿//#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//#Область ПрограммныйИнтерфейс

//// Настройки общей формы отчета подсистемы "Варианты отчетов".
////
//// Параметры:
////   Форма - УправляемаяФорма - Форма отчета.
////   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
////   Настройки - Структура - см. возвращаемое значение ФункцииОтчетовКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
////
//Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
//	БухгалтерскиеОтчеты.ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки);
//	Настройки.Печать.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
//КонецПроцедуры 

//// Функция - Подготовить параметры отчета
////
//// Параметры:
////  НастройкиОтчета	- НастройкиКомпоновкиДанных - пользовательские настройки
//// 
//// Возвращаемое значение:
////  Структура - Параметры отчета
////
//Функция ПодготовитьПараметрыОтчета(НастройкиОтчета)
//	
//	ВыводитьПодписи = Ложь;
//	Заголовок = "Материальный отчет";
//	
//	НачалоПериода = Дата(1,1,1);
//	КонецПериода  = Дата(1,1,1);
//	
//	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СтПериод"));
//	Если ПараметрПериод <> Неопределено И ПараметрПериод.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ Тогда
//		Если ПараметрПериод.Использование
//			И ЗначениеЗаполнено(ПараметрПериод.Значение) Тогда
//			
//			НачалоПериода = ПараметрПериод.Значение.ДатаНачала;
//			КонецПериода  = ПараметрПериод.Значение.ДатаОкончания;
//		КонецЕсли;
//	КонецЕсли;
//	
//	ПараметрВыводитьПодписи = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьПодписи"));
//	Если ПараметрВыводитьПодписи <> Неопределено
//		И ПараметрВыводитьПодписи.Использование Тогда
//		ВыводитьПодписи = ПараметрВыводитьПодписи.Значение;
//	КонецЕсли;
//	
//	ПараметрВывода = НастройкиОтчета.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок"));
//	Если ПараметрВывода <> Неопределено
//		И ПараметрВывода.Использование Тогда
//		Заголовок = ПараметрВывода.Значение;
//	КонецЕсли;
//	
//	ПараметрыОтчета = Новый Структура;
//	ПараметрыОтчета.Вставить("НачалоПериода"            , НачалоПериода);
//	ПараметрыОтчета.Вставить("КонецПериода"             , КонецПериода);
//	ПараметрыОтчета.Вставить("ВыводитьПодписи"        	, ВыводитьПодписи);
//	ПараметрыОтчета.Вставить("Заголовок"                , Заголовок);
//	ПараметрыОтчета.Вставить("ИдентификаторОтчета"      , "МатериальнаыйОтчет");
//	ПараметрыОтчета.Вставить("НастройкиОтчета"			, НастройкиОтчета);
//	
//	Возврат ПараметрыОтчета;
//КонецФункции

//#КонецОбласти

//#Область ОбработчикиСобытий

//// Процедура - обработчик события ПриКомпоновкеРезультата.
//// Выполняет компоновку.
//Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
//	
//	СтандартнаяОбработка = Ложь;
//	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
//	ПараметрыОтчета = ПодготовитьПараметрыОтчета(НастройкиОтчета);
//	
//	БухгалтерскиеОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
//	БухгалтерскиеОтчеты.ВывестиЗаголовокОтчета(ПараметрыОтчета, ДокументРезультат);
//	
//	
//	//Вывод титульного листа
//	ПараметрТитульныйЛист = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ТитульныйЛист"));
//	Если ПараметрТитульныйЛист <> Неопределено
//		И ПараметрТитульныйЛист.Использование Тогда
//		ПечататьТитульныйЛист = ПараметрТитульныйЛист.Значение;
//	КонецЕсли;
//	Если ПечататьТитульныйЛист Тогда 
//		Попытка
//			Таб = ДокументРезультат;
//			Таб.Очистить();
//			
//			ЭлементыОтбора = Новый Массив;
//			ЭлементыОтбора.Вставить("0","ОС");
//			ЭлементыОтбора.Вставить("1","Организация");
//			МассивОтборов = НайтиЭлементыОтбора(НастройкиОтчета, ЭлементыОтбора);
//			Для каждого Строка из МассивОтборов Цикл 
//				//Получим организацию
//				Если ТипЗнч(Строка.ПравоеЗначение) = Тип("СправочникСсылка.Организации")и
//					Строка.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда 
//					Организация = Строка.ПравоеЗначение;
//				Иначе  
//					Организация = ПредопределенноеЗначение("Справочник.Организации.ОсновнаяОрганизация");
//				КонецЕсли;
//				//Получим ОС
//				Если ТипЗнч(Строка.ПравоеЗначение) = Тип("СправочникСсылка.ОсновныеСредства")и
//					Строка.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда 
//					ОС = Строка.ПравоеЗначение;
//				КонецЕсли;
//				
//			КонецЦикла;
//			Если ОС = Неопределено тогда
//				Отказ = Истина;
//				ВызватьИсключение НСтр("ru = 'Не установлен отбор по объекту'");
//			КонецЕсли;
//			Дата = ПараметрыОтчета.НачалоПериода;
//			Если Дата = Дата(1,1,1) тогда
//				Отказ = Истина;
//				ВызватьИсключение НСтр("ru = 'Не установлен отбор по Периоду'");
//			КонецЕсли;
//			//Получим МОЛ из РС МестонахождениеОС
//			ПериодРС = ?(ПараметрыОтчета.КонецПериода> Дата(1,1,1),ПараметрыОтчета.КонецПериода, ТекущаяДата());
//			Отбор = Новый Структура("ОсновноеСредство,Организация",ОС,Организация);
//			ВыборкаМол  = РегистрыСведений.МестонахождениеОС.СрезПоследних(ПериодРС,Отбор);
//			Для Каждого Стр из ВыборкаМол Цикл
//				МОЛ = Стр.МОЛ;
//			КонецЦикла;
//			//заполним и выведим макет
//			Макет = ПолучитьМакет("ТитЛист2");
//			Область = Макет.ПолучитьОбласть("Шапка");
//			
//			Область.Параметры.Дата  = Дата;
//			Область.Параметры.Дата1 = Дата;
//			Область.Параметры.Организация  = Организация;
//			Область.Параметры.Организация1 = Организация;
//			ФИО = "";
//			БухгалтерскийУчетСервер.ФамилияИнициалыПоНаименованию(ФИО,МОЛ.Наименование);
//			Область.Параметры.МОЛ = ФИО;
//			Область.Параметры.Объект = ОС;
//			Таб.Вывести(Область);
//		Исключение
//			Отказ = Истина;
//			Инфо = ИнформацияОбОшибке();
//			ВызватьИсключение  Инфо.Описание;
//		КонецПопытки;
//		
//	КонецЕсли;
//	//конец Вывода титульного листа
//	
//	
//	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
//	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
//	
//	//Создадим и инициализируем процессор компоновки
//	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
//	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);
//	
//	
//	//Создадим и инициализируем процессор вывода результата
//	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
//	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
//	
//	//Обозначим начало вывода
//	ПроцессорВывода.НачатьВывод();
//	ТаблицаЗафиксирована = Ложь;
//	
//	ДокументРезультат.ФиксацияСверху = 0;
//	//Основной цикл вывода отчета
//	Пока Истина Цикл
//		//Получим следующий элемент результата компоновки
//		ЭлементРезультата = ПроцессорКомпоновки.Следующий();
//		
//		Если ЭлементРезультата = Неопределено Тогда
//			//Следующий элемент не получен - заканчиваем цикл вывода
//			Прервать;
//		Иначе
//			// Зафиксируем шапку
//			Если  Не ТаблицаЗафиксирована 
//				И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
//				И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда
//				
//				ТаблицаЗафиксирована = Истина;
//				ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;
//				
//			КонецЕсли;
//			//Элемент получен - выведем его при помощи процессора вывода
//			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
//		КонецЕсли;
//	КонецЦикла;
//	
//	ПроцессорВывода.ЗакончитьВывод();
//	
//	// Вывод подписей
//	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, ДокументРезультат);
//	
//	
//	
//КонецПроцедуры

//#КонецОбласти

//#Область СлужебныеПроцедурыИФункции

//// Возвращает массив найденных элементов отбора
////
//// Параметры:
////		ЭлементСтруктуры - элемент структуры
////		СписокПолей      - Массив - массив строк (имен полей) для поиска
////		Использование    - Неопределено, Булево - признак использования отбора (по умолчанию: Неопределено).
////                         Если Неопределено, то отбираются все элементы, независимо от их использования
////
//Функция НайтиЭлементыОтбора(ЭлементСтруктуры, СписокПолей, СписокЭлементов = Неопределено)
//	
//	Если СписокЭлементов = Неопределено Тогда
//		СписокЭлементов = Новый Массив;
//	КонецЕсли;
//	
//	Если ТипЗнч(ЭлементСтруктуры) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
//		Отбор = ЭлементСтруктуры.Настройки.Отбор;
//	ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("НастройкиКомпоновкиДанных") Тогда
//		Отбор = ЭлементСтруктуры.Отбор;
//	Иначе
//		Отбор = ЭлементСтруктуры;
//	КонецЕсли;
//	
//	Для Каждого ЭлементОтбора Из Отбор.Элементы Цикл
//		Если ЭлементОтбора.Использование <> Истина Тогда
//			Продолжить;
//		КонецЕсли;
//		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
//			ИмяОтбора = Строка(ЭлементОтбора.ЛевоеЗначение);
//			Если СписокПолей.Найти(ИмяОтбора) <> Неопределено Тогда
//				СписокЭлементов.Добавить(ЭлементОтбора);
//			КонецЕсли;
//		ИначеЕсли ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
//			СписокЭлементов = НайтиЭлементыОтбора(ЭлементОтбора, СписокПолей, СписокЭлементов);
//		КонецЕсли;
//	КонецЦикла;
//		
//	Возврат СписокЭлементов;
//	
//КонецФункции

//#КонецОбласти

//#Конецесли
