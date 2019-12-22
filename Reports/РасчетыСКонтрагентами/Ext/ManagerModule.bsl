﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Для подсистемы "Варианты отчетов" при работе в модели сервиса.
//
// Возвращаемое значение:
//  Массив - массив структур (варианты отчета).
Функция ВариантыНастроек() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Новый Структура("Имя, Представление", "РасчетыСКонтрагентами", НСтр("ru = 'Расчеты с контрагентами.'")));
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;

	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "РасчетыСКонтрагентами");
	НастройкиВарианта.Описание = НСтр("ru = 'Расчеты с контрагентами'");
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Возвращает структуру параметров исполнения отчета.
//
// Возвращаемое значение:
//   Структура - Содержит настройки исполнения.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьРасширенныеПараметрыРасшифровки", Истина);
	
	Возврат Результат;

КонецФункции

// Возвращает текст заголовка.
//
// Возвращаемое значение:
//   ТекстЗаголовка - Строка - текст, отображаемый у заголовка формы.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	ПредставлениеПериодаОтчета = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		ПараметрыОтчета.НачалоПериода,
		ПараметрыОтчета.КонецПериода);
		
	ТекстЗаголовкаОтчета = НСтр("ru = 'Расчеты с контрагентами %1'");
		
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаОтчета,
				СокрЛП(ПредставлениеПериодаОтчета));
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	СписокСчетов = БухгалтерскиеОтчетыВызовСервераПовтИсп.СчетаРасчетовСКонтрагентами();
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СчетаУчетаРасчетовСКонтрагентами", СписокСчетов);
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаОстатки", НачалоДня(ПараметрыОтчета.НачалоПериода) + 1);
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериодаОстатки", Дата(1, 1, 1) + 1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаОстатки", КонецДня(ПараметрыОтчета.КонецПериода) + 1);
	Иначе
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериодаОстатки", Дата(3999, 1, 1) + 1);
	КонецЕсли;
	
	НастроитьСтруктуруОтчета(КомпоновщикНастроек, ПараметрыОтчета);
	
КонецПроцедуры

// В процедуре можно доработать макет перед выводом в отчет.
//
// Параметры:
//   ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//   МакетКомпоновки - МакетКомпоновкиДанных - схема получения данных.
//
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	// Определим количество группировок.
	КоличествоГруппировок = 0;
	
	Для Каждого СтрокаТаблицы Из ПараметрыОтчета.Группировка Цикл
		Если СтрокаТаблицы.Использование Тогда
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;

	КоличествоСтрокШапки = Макс(?(КоличествоГруппировок = 1,2,КоличествоГруппировок), 1);
	ПараметрыОтчета.Вставить("ВысотаШапки", КоличествоСтрокШапки + 1);

	// Обработка шапки отчета.
	// Шапка отчета состоит из 4 макетов, макет шапки таблицы, и 3 макета группировок колонок.
	// Поместим ссылки на них в массив, для дальнейшей обработки.
	МакетШапкиТаблицы = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетШапки(МакетКомпоновки);
	
	МакетыШапкиОтчета = Новый Массив;
	МакетыШапкиОтчета.Добавить(МакетШапкиТаблицы.Имя);

	// Определим тело макета таблицы.
	ТелоМакета = Неопределено;
	Для Каждого ТелоМакета Из МакетКомпоновки.Тело Цикл 
		Если ТелоМакета.Имя = "Таблица" Тогда 
			Прервать;
		КонецЕсли;	
	КонецЦикла;	

	Для Каждого Колонка Из ТелоМакета.Колонки Цикл

		Для Каждого ТелоГруппировки Из Колонка.Тело Цикл
			МакетыШапкиОтчета.Добавить(ТелоГруппировки.Макет);
		КонецЦикла;

	КонецЦикла;
	
	// Удалим лишние строки из шапки отчета.
	МассивДляУдаления = Новый Массив;
	
	Для Каждого ИмяМакетаШапкиОтчета Из МакетыШапкиОтчета Цикл
		
		МакетШапкиОтчета = МакетКомпоновки.Макеты[ИмяМакетаШапкиОтчета];
		
		
		Для Индекс = КоличествоСтрокШапки + 1 По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
			
			МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
			
		КонецЦикла;
		
		Для Каждого Элемент Из МассивДляУдаления Цикл
			МакетШапкиОтчета.Макет.Удалить(Элемент);
		КонецЦикла;
		
		// Если группировка только по счету, объединим ячейки заголовка таблицы.
		Если МакетШапкиОтчета = МакетШапкиТаблицы И КоличествоСтрокШапки = 1 Тогда
			
			Для Каждого Ячейка Из МакетШапкиОтчета.Макет[МакетШапкиОтчета.Макет.Количество() - 1].Ячейки Цикл
				
				Оформление = Ячейка.Оформление.Элементы.Найти("ОбъединятьПоВертикали");
				Оформление.Значение = Истина;
				Оформление.Использование = Истина;
				
			КонецЦикла;
			
		КонецЕсли;
			
	КонецЦикла;
	
	// Запомним какие макеты ресурсов каким колонкам соответствуют.
	// Это может понадобиться для обработки развернутого сальдо.
	СоответствиеМакетовКолонкамОтчета = Новый Соответствие;
	
	// Макеты группировки и ресурсов группировки по валюте,
	// будем использовать для определения принадлежности элемента Макет, Макета компоновки к группировке по валюте.
	МакетГруппировкиВалюта = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Валюта");
	МакетРесурсовГруппировкиВалюта = Новый Массив;
	
	МассивИменМакетовВалюта = Новый Массив;
	Для Каждого МакетВалюта Из МакетГруппировкиВалюта Цикл
		МассивИменМакетовВалюта.Добавить(МакетВалюта.Имя);
	КонецЦикла;
	
	ЗаполнитьМакетыРесурсовГруппировки(ТелоМакета.Строки, МакетРесурсовГруппировкиВалюта, СоответствиеМакетовКолонкамОтчета, "Валюта", Истина);
	
	МассивИменМакетовВключенныхВГруппировкуВалюта = Новый Массив;
	НайденаВалюта = Ложь;
	Для Каждого СтрокаГруппировка Из ПараметрыОтчета.Группировка Цикл
		
		Если НЕ СтрокаГруппировка.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаГруппировка.Поле = "Валюта" Тогда
			НайденаВалюта = Истина;
		КонецЕсли;
		
		Если НайденаВалюта Тогда // Нужны все последующие группировки.
			
			МакетГруппировкиВключеннойВВалюту = БухгалтерскиеОтчетыВызовСервера.ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, СтрокаГруппировка.Поле);
			
			Для Каждого МакетВключенныйВВалюту Из МакетГруппировкиВключеннойВВалюту Цикл
				МассивИменМакетовВключенныхВГруппировкуВалюта.Добавить(МакетВключенныйВВалюту.Имя);
			КонецЦикла;
			
			ИменаМакетовРесурсов = ЗаполнитьМакетыРесурсовГруппировки(ТелоМакета.Строки, 
				МакетГруппировкиВключеннойВВалюту, СоответствиеМакетовКолонкамОтчета, СтрокаГруппировка.Поле, Истина);
				
			Если ИменаМакетовРесурсов <> Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивИменМакетовВключенныхВГруппировкуВалюта, ИменаМакетовРесурсов, Истина);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

	//// Если в отчете включена валютная сумма, то ее нужно показывать только по тем счетам
	//// где есть валюта, для того чтобы убрать вывод показателя валюта там где он не нужен.
	//// Переберем все макеты, и удалим строки предназначенные для вывода валютных сумм у всех макетов
	//// кроме макетов группировки по валюте и макетов ресурсов группировки по валюте.
	//Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
	//	Для Каждого Макет Из МакетКомпоновки.Макеты Цикл 
	//		// Пропускаем макеты шапки.
	//		Если МакетыШапкиОтчета.Найти(Макет.Имя) = Неопределено Тогда

	//			Если МассивИменМакетовВалюта.Найти(Макет.Имя) <> Неопределено 
	//				ИЛИ МакетРесурсовГруппировкиВалюта.Найти(Макет.Имя) <> Неопределено
	//				ИЛИ МассивИменМакетовВключенныхВГруппировкуВалюта.Найти(Макет.Имя) <> Неопределено Тогда


	//			ИначеЕсли Макет.Макет.Количество() > 1 Тогда // Последний не удаляем.

	//				Макет.Макет.Удалить(Макет.Макет.Количество() - 1);

	//			КонецЕсли;

	//		КонецЕсли;

	//	КонецЦикла;

	//КонецЕсли;
КонецПроцедуры

// В процедуре можно доработать результат отчета, выводимый в табличный документ.
//
// Параметры:
//   ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//   Результат   - ТабличныйДокумент - результат выполнения отчета.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	// Вывод подписей
	БухгалтерскиеОтчеты.ВыводПодписейОтчета(ПараметрыОтчета, Результат);
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает набор показателей отчета.
// Возвращаемое значение:
//   НаборПоказателей - Массив.
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("Сумма");
	НаборПоказателей.Добавить("ВалютнаяСумма");
	
	Возврат НаборПоказателей;
	
КонецФункции

// Задает набор опций, которые позволяет настраивать отчет.
//
// Возвращаемое значение:
//   Массив      - имена опций.
//
Функция СохраняемыеОпции() Экспорт
	
	КоллекцияНастроек = Новый Массив;
	Для каждого Показатель Из ПолучитьНаборПоказателей() Цикл
		КоллекцияНастроек.Добавить("Показатель" + Показатель);
	КонецЦикла;
	КоллекцияНастроек.Добавить("Периодичность");
	КоллекцияНастроек.Добавить("РазмещениеДополнительныхПолей");
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает набор параметров, которые необходимо сохранять в рассылке отчетов.
// Значения параметров используются при формировании отчета в рассылке.
//
// Возвращаемое значение:
//   Структура - структура настроек, сохраняемых в рассылке с неинициализированными значениями.
//
Функция НастройкиОтчетаСохраняемыеВРассылке() Экспорт
	
	КоллекцияНастроек = Новый Структура;
	КоллекцияНастроек.Вставить("Организация"                      , Справочники.Организации.ПустаяСсылка());
	КоллекцияНастроек.Вставить("РазмещениеДополнительныхПолей"    , 0);
	КоллекцияНастроек.Вставить("Группировка"                      , Неопределено);
	КоллекцияНастроек.Вставить("ДополнительныеПоля"               , Неопределено);
	КоллекцияНастроек.Вставить("ВыводитьЗаголовок"                , Ложь);
	КоллекцияНастроек.Вставить("ВыводитьПодвал"                   , Ложь);
	КоллекцияНастроек.Вставить("МакетОформления"                  , Неопределено);
	КоллекцияНастроек.Вставить("НастройкиКомпоновкиДанных"        , Неопределено);
	
	Возврат КоллекцияНастроек;
	
КонецФункции

// Возвращает структуру параметров, наличие которых требуется для успешного формирования отчета.
//
// Возвращаемое значение:
//   Структура - структура параметров для формирования отчета.
//
Функция ПустыеПараметрыКомпоновкиОтчета() Экспорт
	
	// Часть параметров компоновки отчета используется так же и в рассылке отчета.
	ПараметрыОтчета = НастройкиОтчетаСохраняемыеВРассылке();
	
	// Дополним параметрами, влияющими на формирование отчета.
	ПараметрыОтчета.Вставить("ПериодОтчета"         , Неопределено);
	ПараметрыОтчета.Вставить("НачалоПериода"        , Дата(1,1,1));
	ПараметрыОтчета.Вставить("КонецПериода"         , Дата(1,1,1));
	ПараметрыОтчета.Вставить("РежимРасшифровки"     , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"    , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных", Неопределено);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"  , "");
	ПараметрыОтчета.Вставить("НаборПоказателей"     , Неопределено);
	ПараметрыОтчета.Вставить("ПоказательСумма"     	, Ложь);
	ПараметрыОтчета.Вставить("ПоказательВалютнаяСумма"     , Ложь);
	ПараметрыОтчета.Вставить("Периодичность"     	, 2);
	                                                
	Возврат ПараметрыОтчета;
	
КонецФункции

Процедура ЗаполнитьПараметрыРасшифровкиОтчета(Адрес, Расшифровка, ПараметрыРасшифровки) Экспорт
	
	// Инициализируем список мунктов меню
	СписокПунктовМеню = Новый СписокЗначений();
	
	// Заполним соответствие полей которые мы хотим получить из данных расшифровки
	СоответствиеПолей = Новый Соответствие;
	ДанныеОтчета = ПолучитьИзВременногоХранилища(Адрес);
	
	ЗначениеРасшифровки = ДанныеОтчета.ДанныеРасшифровки.Элементы[Расшифровка];
	Если ТипЗнч(ЗначениеРасшифровки) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
		Для Каждого ПолеРасшифровки Из ЗначениеРасшифровки.ПолучитьПоля() Цикл
			Если ЗначениеЗаполнено(ПолеРасшифровки.Значение) Тогда
				ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Истина);
				ПараметрыРасшифровки.Вставить("Значение",  ПолеРасшифровки.Значение);
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Укажем что открывать объект сразу не нужно
	ПараметрыРасшифровки.Вставить("ОткрытьОбъект", Ложь);
	
	Если ДанныеОтчета = Неопределено Тогда 
		ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
		Возврат;
	КонецЕсли;
	
	// Прежде всего интересны данные группировочных полей
	Для Каждого Группировка Из ДанныеОтчета.Объект.Группировка Цикл
		СоответствиеПолей.Вставить(Группировка.Поле);
	КонецЦикла;
	
	// Инициализация пользовательских настроек
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	ДополнительныеСвойства.Вставить("РежимРасшифровки", 					Истина);
	ДополнительныеСвойства.Вставить("Организация", 							ДанныеОтчета.Объект.Организация);
	ДополнительныеСвойства.Вставить("НачалоПериода", 						ДанныеОтчета.Объект.НачалоПериода);
	ДополнительныеСвойства.Вставить("КонецПериода", 						ДанныеОтчета.Объект.КонецПериода);
	ДополнительныеСвойства.Вставить("ВыводитьЗаголовок",					ДанныеОтчета.Объект.ВыводитьЗаголовок);
	ДополнительныеСвойства.Вставить("ВыводитьПодвал",						ДанныеОтчета.Объект.ВыводитьПодвал);
	ДополнительныеСвойства.Вставить("МакетОформления",						ДанныеОтчета.Объект.МакетОформления);
	//ДополнительныеСвойства.Вставить("Контрагент", 							ДанныеОтчета.Объект.Контрагент);
	//ДополнительныеСвойства.Вставить("ДоговорКонтрагента", 					ДанныеОтчета.Объект.ДоговорКонтрагента);
	
	// Получаем соответствие полей доступных в расшифровке
	Данные_Расшифровки = БухгалтерскиеОтчеты.ПолучитьДанныеРасшифровки(ДанныеОтчета.ДанныеРасшифровки, СоответствиеПолей, Расшифровка);
	
	Контрагент 			= Данные_Расшифровки.Получить("Контрагент");
	ДоговорКонтрагента 	= Данные_Расшифровки.Получить("ДоговорКонтрагента");
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ДополнительныеСвойства.Вставить("Контрагент", Контрагент);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
		ДополнительныеСвойства.Вставить("ДоговорКонтрагента", ДоговорКонтрагента);
	КонецЕсли;
	
	ОтборПоЗначениямРасшифровки = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ОтборПоЗначениямРасшифровки.ИдентификаторПользовательскойНастройки = "Отбор";
	
	Для Каждого ЗначениеРасшифровки Из Данные_Расшифровки Цикл
		
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ОтборПоЗначениямРасшифровки, ЗначениеРасшифровки.Ключ, ЗначениеРасшифровки.Значение);
		
	КонецЦикла;
	
	СписокПунктовМеню.Добавить("РасшифровкаРасчетовСКонтрагентами", "Расшифровка расчетов с контрагентами");
	
	НастройкиРасшифровки = Новый Структура();
	НастройкиРасшифровки.Вставить("РасшифровкаРасчетовСКонтрагентами", ПользовательскиеНастройки);
	ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	
	ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	
	ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
	//Группировка = Новый Массив();
	//ЕстьГруппировкаПоДокументу = Ложь;
	//Для Каждого СтрокаГруппировки Из ДанныеОтчета.Объект.Группировка Цикл
	//	Если СтрокаГруппировки.Использование Тогда
	//		СтрокаДляРасшифровки = Новый Структура("Использование, Поле, Представление, ТипГруппировки");
	//		ЗаполнитьЗначенияСвойств(СтрокаДляРасшифровки, СтрокаГруппировки);
	//		Группировка.Добавить(СтрокаДляРасшифровки);
	//		
	//		Если СтрокаГруппировки.Поле = "Документ" Тогда
	//			
	//			ЕстьГруппировкаПоДокументу = Истина;
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЦикла;
	//
	//Если НЕ ЕстьГруппировкаПоДокументу Тогда
	//	
	//	СтрокаДляРасшифровки = Новый Структура();
	//	СтрокаДляРасшифровки.Вставить("Использование", 	Истина);
	//	СтрокаДляРасшифровки.Вставить("Поле", 			"Документ");
	//	СтрокаДляРасшифровки.Вставить("Представление", 	"Документ");
	//	СтрокаДляРасшифровки.Вставить("ТипГруппировки", 0);
	//	
	//	Группировка.Добавить(СтрокаДляРасшифровки);
	//	
	//КонецЕсли;
	//
	//ДополнительныеСвойства.Вставить("Группировка", Группировка);
	
	//СписокПунктовМеню.Добавить("РасчетыСКонтрагентами", "Расчеты с контрагентами");
	
	//НастройкиРасшифровки = Новый Структура();
	//НастройкиРасшифровки.Вставить("РасчетыСКонтрагентами", ПользовательскиеНастройки);
	//ДанныеОтчета.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
	//
	//ПоместитьВоВременноеХранилище(ДанныеОтчета, Адрес);
	//
	//ПараметрыРасшифровки.Вставить("СписокПунктовМеню", СписокПунктовМеню);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаполнитьМакетыРесурсовГруппировки(Таблица, МассивМакетов, СоответствиеМакетовКолонкамОтчета, ПолеГруппировки = Неопределено, ВключатьМакетыВложенныхГруппировок = Ложь, ПрочитатьМакетыРесурсов = Ложь)
	
	// Перебираем все элементы макета.
	Для Каждого Группировка Из Таблица Цикл
		
		Если ТипЗнч(Группировка) = Тип("ГруппировкаТаблицыМакетаКомпоновкиДанных") Тогда
			// Если это группировка проверим поле группировки.
			Если ПолеГруппировки = Неопределено ИЛИ (Группировка.Группировка.Количество() > 0 И Группировка.Группировка[0].ИмяПоля = ПолеГруппировки) Тогда  // Группировка.Группировка[0].ИмяПоля = ПолеГруппировки Тогда
				
				Если ВключатьМакетыВложенныхГруппировок Тогда
					// Перебираем вложенные группировки, условие по полю группировки в них не накладываем.
					ЗаполнитьМакетыРесурсовГруппировки(Группировка.Тело, МассивМакетов, СоответствиеМакетовКолонкамОтчета,,,Истина);
				Иначе
					ЗаполнитьМакетыРесурсовГруппировки(Группировка.Тело, МассивМакетов, СоответствиеМакетовКолонкамОтчета, ПолеГруппировки, ВключатьМакетыВложенныхГруппировок, Истина);
				КонецЕсли;
				
				// Перебираем иерархию группировки.
				Для Каждого ТелоИерархии Из Группировка.ТелоИерархии Цикл
					
					Если ТипЗнч(ТелоИерархии) = Тип("МакетГруппировкиТаблицыМакетаКомпоновкиДанных") Тогда
						
						Для Каждого МакетРесурсов Из ТелоИерархии.МакетРесурсов Цикл
							// Помещаем макеты в массив.
							МассивМакетов.Добавить(МакетРесурсов.Макет);
							// Добавляем соответствие макетов ресурсов и колонок отчета.
							СоответствиеМакетовКолонкамОтчета.Вставить(МакетРесурсов.Макет, МакетРесурсов.МакетГруппировки);
							
						КонецЦикла;
						
					КонецЕсли;
				
				КонецЦикла;
				
			Иначе
				// Если эта группировка не подошла по условию проверим вложенные группировки.
				ЗаполнитьМакетыРесурсовГруппировки(Группировка.Тело, МассивМакетов, СоответствиеМакетовКолонкамОтчета, ПолеГруппировки, ВключатьМакетыВложенныхГруппировок);

			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Группировка) = Тип("МакетГруппировкиТаблицыМакетаКомпоновкиДанных") И ПрочитатьМакетыРесурсов Тогда
			
			Для Каждого МакетРесурсов Из Группировка.МакетРесурсов Цикл
				
				// Помещаем макеты в массив.
				МассивМакетов.Добавить(МакетРесурсов.Макет);
				// Добавляем соответствие макетов ресурсов и колонок отчета.
				СоответствиеМакетовКолонкамОтчета.Вставить(МакетРесурсов.Макет, МакетРесурсов.МакетГруппировки);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

// Добавляет параметр в схему компоновки данных и присваивает ему значение.
// Параметры:
//  ИмяПараметра - Строка - Имя (Ключ) нового параметра.
//  ЗначениеПараметра - Произвольный - Значение которое нужно присвоить параметру.
Процедура ДобавитьПараметрСхемыКомпоновки(ИмяПараметра, ЗначениеПараметра, СхемаКомпоновкиДанных)
	
	НовыйПараметр = СхемаКомпоновкиДанных.Параметры.Найти(ИмяПараметра);
	
	Если НовыйПараметр = Неопределено Тогда
		НовыйПараметр = СхемаКомпоновкиДанных.Параметры.Добавить();
	КонецЕсли;
	
	НовыйПараметр.Имя 						= ИмяПараметра;
	НовыйПараметр.Значение 					= ЗначениеПараметра;
	НовыйПараметр.ВключатьВДоступныеПоля 	= Ложь;
	НовыйПараметр.ОграничениеИспользования	= Истина;
	НовыйПараметр.Использование 			= ИспользованиеПараметраКомпоновкиДанных.Всегда;
	
КонецПроцедуры

#Область ДоработкаСхемыКомпоновкиДанных

Процедура НастроитьСтруктуруОтчета(КомпоновщикНастроек, ПараметрыОтчета)
	
	// Очищаем структуру отчета и выбранные поля.
	// Они будут перезаполнены в соответствии с настройками которые сделал пользователь.
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	Таблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
	
	ВидыОстатка = Новый Массив;
	ВидыОстатка.Добавить("");
	
	//Если ПараметрыОтчета.РазвернутоеСальдо Тогда
	//	ВидыОстатка.Добавить("Развернутый");
	//КонецЕсли;
	
	Если КоличествоПоказателей > 1 Тогда
		
		Колонка = Таблица.Колонки.Добавить();
		Колонка.Имя = "Показатели";
		ГруппаПоказатели = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок     = БухгалтерскиеОтчеты.ЗаголовокГруппыПоказателей();
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		Для Каждого ВидОстатка Из ВидыОстатка Цикл
			Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
				Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
					БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя + ВидОстатка);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
	// Для начального сальдо, оборотов и конечного сальдо создадим по отдельной колонке.
	// В каждой колонке будет 2 ячейки дебет и кредит.
	
	// Колонка Начальное сальдо.
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя = "СальдоНаНачалоПериода";
	ГруппаСальдоНаНачало = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачало.Заголовок     = СтрШаблон(НСтр("ru = 'Остаток на %1'"), Формат(ПараметрыОтчета.НачалоПериода, "ДФ=dd.MM.yyyy"));
	ГруппаСальдоНаНачало.Использование = Истина;
	ГруппаСальдоНаНачалоДт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоДт.Заголовок     = НСтр("ru = 'Дебет'");
	ГруппаСальдоНаНачалоДт.Использование = Истина;
	ГруппаСальдоНаНачалоДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаНачалоКт = ГруппаСальдоНаНачало.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаНачалоКт.Заголовок     = НСтр("ru = 'Кредит'");
	ГруппаСальдоНаНачалоКт.Использование = Истина;
	ГруппаСальдоНаНачалоКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	// Колонка Обороты.
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя = "ОборотыЗаПериод";
	ГруппаОбороты = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОбороты.Заголовок     = НСтр("ru = 'Обороты за период'");
	ГруппаОбороты.Использование = Истина;
	ГруппаОборотыДт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыДт.Заголовок     = НСтр("ru = 'Дебет'");
	ГруппаОборотыДт.Использование = Истина;
	ГруппаОборотыДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаОборотыКт = ГруппаОбороты.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаОборотыКт.Заголовок     = НСтр("ru = 'Кредит'");
	ГруппаОборотыКт.Использование = Истина;
	ГруппаОборотыКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
	// Колонка Конечное сальдо.
	Колонка = Таблица.Колонки.Добавить();
	Колонка.Имя = "СальдоНаКонецПериода";
	ГруппаСальдоНаКонец = Колонка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонец.Заголовок     = СтрШаблон(НСтр("ru = 'Остаток на %1'"), Формат(ПараметрыОтчета.КонецПериода, "ДФ=dd.MM.yyyy"));
	ГруппаСальдоНаКонец.Использование = Истина;
	ГруппаСальдоНаКонецДт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецДт.Заголовок     = НСтр("ru = 'Дебет'");
	ГруппаСальдоНаКонецДт.Использование = Истина;
	ГруппаСальдоНаКонецДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	ГруппаСальдоНаКонецКт = ГруппаСальдоНаКонец.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаСальдоНаКонецКт.Заголовок     = НСтр("ru = 'Кредит'");
	ГруппаСальдоНаКонецКт.Использование = Истина;
	ГруппаСальдоНаКонецКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ВидОстатка Из ВидыОстатка Цикл
		
		Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоДт, "СальдоНаНачалоПериода." + ИмяПоказателя + "НаНачало" + ВидОстатка + "ОстатокДт");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаНачалоКт, "СальдоНаНачалоПериода." + ИмяПоказателя + "НаНачало" + ВидОстатка + "ОстатокКт");
				
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыДт,        "ОборотыЗаПериод."       + ИмяПоказателя + ВидОстатка + "ОборотДт");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаОборотыКт,        "ОборотыЗаПериод."       + ИмяПоказателя + ВидОстатка + "ОборотКт");
				
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецДт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "НаКонец"  + ВидОстатка + "ОстатокДт");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаСальдоНаКонецКт,  "СальдоНаКонецПериода."  + ИмяПоказателя + "НаКонец"  + ВидОстатка + "ОстатокКт");
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Дополнительные данные.
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	УсловноеОформлениеАвтоотступа = Неопределено;
	Для каждого ЭлементОформления Из КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = НСтр("ru = 'Уменьшенный автоотступ'") Тогда
			УсловноеОформлениеАвтоотступа = ЭлементОформления;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа = Неопределено Тогда
		УсловноеОформлениеАвтоотступа = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		УсловноеОформлениеАвтоотступа.Представление = НСтр("ru = 'Уменьшенный автоотступ'");
		УсловноеОформлениеАвтоотступа.Оформление.УстановитьЗначениеПараметра("Автоотступ", 1);
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
		УсловноеОформлениеАвтоотступа.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		УсловноеОформлениеАвтоотступа.Поля.Элементы.Очистить();
	КонецЕсли;
	
	Структура = Таблица.Строки.Добавить();
	
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Структура = Структура.Структура.Добавить();
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
			ПолеОформления.Поле = ПолеГруппировки.Поле;
		КонецЕсли;
	КонецЦикла;
		
	// Валюта.
	Если ПараметрыОтчета.ПоказательВалютнаяСумма И БухгалтерскиеОтчетыКлиентСервер.НайтиГруппировку(Таблица.Строки, "Валюта") = Неопределено Тогда
		Структура = Структура.Структура.Добавить();
		ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Валюта");
		Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
		
		ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
		ПолеОформления.Поле = ПолеГруппировки.Поле;
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	Если УсловноеОформлениеАвтоотступа.Поля.Элементы.Количество() = 0 Тогда
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
	КонецЕсли;

КонецПроцедуры

Функция РазделительЗапросов(Счетчик)
	
	Если Счетчик = 1 Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|";

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
