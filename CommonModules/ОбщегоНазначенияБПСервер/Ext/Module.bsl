﻿
// Процедура добавляет в массив МассивНепроверяемыхРеквизитов элементы, соответствующие именам 
// в зависимости от значений функциональных опций.
// Для использования в обработчиках события ОбработкаПроверкиЗаполнения.
//
// Параметры:
//	МассивНепроверяемыхРеквизитов - Массив строк с именами реквизитов объекта, не требующих проверки.
//	Организация - СправочникСсылка.Организации - Ссылка на организацию.
//	Период - Дата - Дата установки периодических опций.
//
Процедура ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, Период = Неопределено) Экспорт
	
	ПараметрыФО = Новый Структура();
	ПараметрыФО.Вставить("Организация", Организация);
	Если Период <> Неопределено Тогда
		ПараметрыФО.Вставить("Период", НачалоМесяца(Период));
		// Приводим к началу месяца для того, чтобы сократить пространство кэшируемых значений.
		// Параметр "Организация" используется в функциональных опциях, привязанных к регистрам сведений с периодичностью Месяц или реже.
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ПлательщикНДС", ПараметрыФО) Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНДС");
		МассивНепроверяемыхРеквизитов.Добавить("ВидПоставкиНДС");
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ПлательщикНСП", ПараметрыФО) Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСП");
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНСПУслуги");
	КонецЕсли;	
	
	Если НЕ ПолучитьФункциональнуюОпцию("ПлательщикЕН", ПараметрыФО) Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("ВидДеятельности");
	КонецЕсли;
КонецПроцедуры

// Получает строку, содержащую ключи структуры, разделенные символом разделителя.
//
// Параметры:
//	СтруктураДляПреобразования - Структура - Структура, ключи которой преобразуются в строку.
//	Разделитель - Строка - Разделитель, который вставляется в строку между ключами структуры.
//
// Возвращаемое значение:
//	Результат - Строка, содержащая ключи структуры разделенные разделителем.
//
Функция СтруктураВСтроку(СтруктураДляПреобразования, Разделитель = ",") Экспорт
	
	Результат = "";
	
	Для Каждого Элемент Из СтруктураДляПреобразования Цикл
		
		СимволРазделителя = ?(ПустаяСтрока(Результат), "", Разделитель);
		
		Результат = Результат + СимволРазделителя + Элемент.Ключ;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Получает структуру, содержащую пустые ключи структуры, из строки, разделенной символом разделителя.
//
// Параметры:
//	СтрокаДляПреобразования - Строка - СтрокаДляПреобразования, из которой формируются ключи структуры.
//	Разделитель - Строка - Разделитель, который вставляется в строку между ключами структуры.
//
// Возвращаемое значение:
//	Результат - Строка, содержащая ключи структуры разделенные разделителем.
//
Функция СтрокаВСтруктуру(СтрокаДляПреобразования, Разделитель = ",") Экспорт
	
	Результат = Новый Структура;
	СтрокаПоискаСвойств = СтрокаДляПреобразования;
	
	ПозицияРазделителя = СтрНайти(СтрокаПоискаСвойств,Разделитель);
	Пока ПозицияРазделителя <> 0 Цикл
		Результат.Вставить(СокрЛП(Лев(СтрокаПоискаСвойств, ПозицияРазделителя-1)));
		СтрокаПоискаСвойств = Сред(СтрокаПоискаСвойств, ПозицияРазделителя+1);
		ПозицияРазделителя = СтрНайти(СтрокаПоискаСвойств,Разделитель);
	КонецЦикла;
	Результат.Вставить(СокрЛП(СтрокаПоискаСвойств));
	
	Возврат Результат;
	
КонецФункции

Функция ДоступенПростойИнтерфейс() Экспорт
	
	Возврат ОбщегоНазначенияПовтИсп.РазделениеВключено() 
		И ВРЕГ(Метаданные.Имя) = ВРЕГ("БухгалтерияДляКыргызстанаБазовая");
	
КонецФункции

// Установка набора видимых подсистем командного интерфейса 
// и настроек всем пользователям вида интерфейса (Такси / в закладках).
//
// Параметры:
//  Режим - Строка - ИнтерфейсТакси / ИнтерфейсВерсии82 / ИнтерфейсВерсии77 - соответствует константе, которая будет установлена в Истину
//
Процедура УстановитьРежимКомандногоИнтерфейса(Режим) Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	// Установка констант
	РежимТакси = ВРег(Режим) = ВРег("ИнтерфейсТакси");
	Режим82 = ВРег(Режим) = ВРег("ИнтерфейсВерсии82");
	
	Если НЕ РежимТакси
		И НЕ Режим82 Тогда
		Возврат;
	КонецЕсли;
	
	Если ДоступенПростойИнтерфейс()
		И Режим82 Тогда
		// Если доступен простой интерфейс, то переключаться
		// на режим 8.2 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	РежимСоответствуетТекущему = РежимТакси = Константы.ИнтерфейсТакси.Получить()
		И Режим82 = Константы.ИнтерфейсВерсии82.Получить();
	
	Константы.ИнтерфейсТакси.Установить(РежимТакси);
	Константы.ИнтерфейсВерсии82.Установить(Режим82);
	
	// Установка настроек по умолчанию всем пользователям
	
	ВсеПользователи = ПользователиИнформационнойБазы.ПолучитьПользователей();
	НовыйИнтерфейсПользователей = ?(РежимТакси, ВариантИнтерфейсаКлиентскогоПриложения.Такси, 
		ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2);
		
	Если ВсеПользователи.Количество() > 0 Тогда
		Для каждого ПользовательИБ Из ВсеПользователи Цикл
			УстановитьНачальныеНастройки = Истина;
			Если РежимСоответствуетТекущему Тогда
				// Не меняем настройки, если интерфейс пользователя и ранее соответствовал устанавливаемому.
				НастройкиКлиента = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, ПользовательИБ.Имя);
				Если НастройкиКлиента <> Неопределено Тогда
					ТекущийИнтерфейсПользователя = НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения;
					УстановитьНачальныеНастройки = ТекущийИнтерфейсПользователя <> НовыйИнтерфейсПользователей;
				КонецЕсли;
			КонецЕсли;
			Если УстановитьНачальныеНастройки Тогда
				ПользователиСлужебный.УстановитьНачальныеНастройки(ПользовательИБ.Имя);
			КонецЕсли;
		КонецЦикла;
	Иначе
		УстановитьНачальныеНастройки = Истина;
		Если РежимСоответствуетТекущему Тогда
			// Не меняем настройки, если интерфейс пользователя и ранее соответствовал устанавливаемому.
			НастройкиКлиента = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, "");
			Если НастройкиКлиента <> Неопределено Тогда
				ТекущийИнтерфейсПользователя = НастройкиКлиента.ВариантИнтерфейсаКлиентскогоПриложения;
				УстановитьНачальныеНастройки = ТекущийИнтерфейсПользователя <> НовыйИнтерфейсПользователей;
			КонецЕсли;
		КонецЕсли;
		Если УстановитьНачальныеНастройки Тогда
			ПользователиСлужебный.УстановитьНачальныеНастройки("");
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Функция ПредлагатьОбновитьВерсиюПрограммы(Параметры) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Параметры.Вставить("ЭтоАдминистраторСистемы", ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы().ЭтоАдминистраторСистемы);
	ДатаТекущейВерсии = Константы.ДатаТекущейВерсии.Получить();
	НадоПредлагать = ЗначениеЗаполнено(ДатаТекущейВерсии) 
		И ТекущаяДатаСеанса() > ДобавитьМесяц(ДатаТекущейВерсии, 2);
	Возврат НадоПредлагать;
	
КонецФункции

#Область ЗапросВФайл

// Записывает Запрос(текст и параметры запроса) в файл XML.
//
// Параметры:
//  Запрос		- запрос - передаваемый Запрос.
//  ИмяФайла	- строка - имя файла.
// 
// Возвращаемое значение:
//  ИмяФайла - имя файла XML.
//
Функция ЗаписатьЗапросВФайлXML(Запрос, ИмяФайла = "") Экспорт
	
	ФайлXML = Новый ЗаписьXML;
	Если ИмяФайла = "" Тогда 
		ИмяФайла = ПолучитьИмяВременногоФайла("q1c");
	КонецЕсли;	
	ФайлXML.ОткрытьФайл(ИмяФайла);
	ФайлXML.ЗаписатьОбъявлениеXML();
	ФайлXML.ЗаписатьНачалоЭлемента("querylist");
	// Цикл запросов.
	//Для каждого ТекЗапрос Из Объект.Запросы Цикл
		ФайлXML.ЗаписатьНачалоЭлемента("query");
		ФайлXML.ЗаписатьАтрибут("name", "Тест");
			ФайлXML.ЗаписатьНачалоЭлемента("text");
			ТекстЗапроса = Запрос.Текст;
			Для Счетчик = 1 По СтрЧислоСтрок(ТекстЗапроса) Цикл
				ПереносСтр	= Символы.ВК + Символы.ПС;
				ТекСтрока 	= СтрПолучитьСтроку(ТекстЗапроса, Счетчик);
				ФайлXML.ЗаписатьТекст(ТекСтрока);
				ФайлXML.ЗаписатьБезОбработки(ПереносСтр);
			КонецЦикла;
			ФайлXML.ЗаписатьКонецЭлемента();
			//ИдентификаторЗапроса = ТекЗапрос.Идентификатор;
			// Запись параметров в XML-файл.
			Если Запрос.Параметры.Количество() > 0 Тогда 
				ФайлXML.ЗаписатьНачалоЭлемента("parameters");
				Для каждого ТекПараметр Из Запрос.Параметры Цикл 
					//Если ТекПараметр.ИдентификаторЗапроса = ИдентификаторЗапроса Тогда 
						ИмяПараметра		= ТекПараметр.Ключ;
						ТипПараметра		= ТипЗнч(ТекПараметр.Значение);
						Значение			= ТекПараметр.Значение;
						Если ПустаяСтрока(Значение) Тогда
							ЗначениеПараметра = ""; 
						Иначе
							ЗначениеПараметра = ТекПараметр.Значение;
						КонецЕсли;	
						
						ФайлXML.ЗаписатьНачалоЭлемента("parameter");
						ФайлXML.ЗаписатьАтрибут("name", ИмяПараметра);
						Если ТипПараметра = "СписокЗначений" Тогда 
							ФайлXML.ЗаписатьАтрибут("type", ТипПараметра);
							ЗаписатьСписокЗначенийВXML(ФайлXML, ЗначениеПараметра);
						ИначеЕсли ТипПараметра = "ТаблицаЗначений" Тогда
							ФайлXML.ЗаписатьАтрибут("type", ТипПараметра);
							
							Колонки = ЗначениеПараметра.Колонки.Количество();
							Строки = ЗначениеПараметра.Количество();
							
							ФайлXML.ЗаписатьАтрибут("colcount", XMLСтрока(Колонки));
							ФайлXML.ЗаписатьАтрибут("rowcount", XMLСтрока(Строки));
							
							ЗаписатьТаблицуЗначенийВXML(ФайлXML, ЗначениеПараметра);
						ИначеЕсли ТипПараметра = "МоментВремени" Тогда
							ФайлXML.ЗаписатьАтрибут("type", ТипПараметра);
							ЗаписатьМоментВремениВXML(ФайлXML, ЗначениеПараметра);
						ИначеЕсли ТипПараметра = "Граница" Тогда
							ФайлXML.ЗаписатьАтрибут("type", ТипПараметра);
							ЗаписатьГраницуВXML(ФайлXML, ЗначениеПараметра);
						Иначе
							ИмяТипа = ИмяТипаИзЗначения(ЗначениеПараметра); 
							ФайлXML.ЗаписатьАтрибут("type", ИмяТипа);
							ФайлXML.ЗаписатьАтрибут("value", XMLСтрока(ЗначениеПараметра));
						КонецЕсли;	
						ФайлXML.ЗаписатьКонецЭлемента();
					//КонецЕсли;	
				КонецЦикла;	
				ФайлXML.ЗаписатьКонецЭлемента();
			КонецЕсли;	
		ФайлXML.ЗаписатьКонецЭлемента();
	//КонецЦикла;	
	ФайлXML.ЗаписатьКонецЭлемента();
	ФайлXML.Закрыть();
	
	//ВозвращаемоеЗначение = Новый ДвоичныеДанные(ИмяФайла);
	
	//УдалитьФайлы(ИмяФайла);
	
	ТекстСообщения = СтрШаблон(НСтр("ru = 'ВНИМАНИЕ! Запрос записан в файл: %1! Просьба после отладки удалить код, вызывающий эту функцию.'"), ИмяФайла);
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	Возврат ИмяФайла;
	
КонецФункции

// Записывает строки списка значений в Файл XML.
//
// Параметры:
//	ФайлXML - записьXML.
//	Значение - список значений.
//
Процедура ЗаписатьСписокЗначенийВXML(ФайлXML, Значение)
	Если ТипЗнч(Значение) <> Тип("СписокЗначений") Тогда 
		Возврат;
	КонецЕсли;	
	
	Для каждого СтрСписка Из Значение Цикл
		ЗначениеЭлементаСписка	= СтрСписка.Значение;
		// Определение имени типа.
		ИмяТипа = ИмяТипаИзЗначения(ЗначениеЭлементаСписка); 
		
		ФайлXML.ЗаписатьНачалоЭлемента("item");
			ФайлXML.ЗаписатьАтрибут("type", ИмяТипа);
			ФайлXML.ЗаписатьАтрибут("value", XMLСтрока(ЗначениеЭлементаСписка));
		ФайлXML.ЗаписатьКонецЭлемента();
	КонецЦикла;
КонецПроцедуры

// Записывает ячейки таблицы значений в Файл XML.
//
// Параметры:
//	ФайлXML - записьXML.
//	Значение - таблица значений.
//
Процедура ЗаписатьТаблицуЗначенийВXML(ФайлXML, Значение)
	Если ТипЗнч(Значение) <> Тип("ТаблицаЗначений") Тогда 
		Возврат;
	КонецЕсли;
	
	КолКолонок 	= Значение.Колонки.Количество();
	КолСтрок	= Значение.Количество();
	
	Для СтрокаИндекс = 0 По КолСтрок - 1 Цикл
		Для КолонкаИндекс = 0 По КолКолонок - 1 Цикл 
			ЗначениеЭлементаСписка	= Значение.Получить(СтрокаИндекс).Получить(КолонкаИндекс);
			ИмяКолонки = Значение.Колонки.Получить(КолонкаИндекс).Имя;
			// Определение имени типа.
			ИмяТипа = ИмяТипаИзЗначения(ЗначениеЭлементаСписка); 
			Если ИмяТипа = "Строка" Тогда 
				Длина = Значение.Колонки.Получить(КолонкаИндекс).ТипЗначения.КвалификаторыСтроки.Длина; 	
			Иначе 
				Длина = 0;
			КонецЕсли; 
			
			ФайлXML.ЗаписатьНачалоЭлемента("item");
				ФайлXML.ЗаписатьАтрибут("nameCol", ИмяКолонки);
				ФайлXML.ЗаписатьАтрибут("row", XMLСтрока(СтрокаИндекс));
				ФайлXML.ЗаписатьАтрибут("col", XMLСтрока(КолонкаИндекс));
				ФайлXML.ЗаписатьАтрибут("type", ИмяТипа);
				ФайлXML.ЗаписатьАтрибут("length", XMLСтрока(Длина));
				ФайлXML.ЗаписатьАтрибут("value", XMLСтрока(ЗначениеЭлементаСписка));
			ФайлXML.ЗаписатьКонецЭлемента();
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

// Записывает момент времени в Файл XML.
//
// Параметры:
//	ФайлXML - записьXML.
//	Значение - момент времени.
//
Процедура ЗаписатьМоментВремениВXML(ФайлXML, Значение)
	Если ТипЗнч(Значение) <> Тип("МоментВремени") Тогда 
		Возврат;
	КонецЕсли;
	
	// Определение имени типа.
	ИмяТипа = ИмяТипаИзЗначения(Значение.Ссылка); 
	
	ФайлXML.ЗаписатьНачалоЭлемента("item");
		Если Значение.Ссылка <> Неопределено Тогда 
			ФайлXML.ЗаписатьАтрибут("type", ИмяТипа);
			ФайлXML.ЗаписатьАтрибут("valueRef", XMLСтрока(Значение.Ссылка));
		КонецЕсли;	
		ФайлXML.ЗаписатьАтрибут("valueDate", XMLСтрока(Значение.Дата));
	ФайлXML.ЗаписатьКонецЭлемента();
КонецПроцедуры	

// Записывает границу.
//
Процедура ЗаписатьГраницуВXML(ФайлXML, Граница)
	Если ТипЗнч(Граница) <> Тип("Граница") Тогда
		Возврат;
	КонецЕсли;
	
	ФайлXML.ЗаписатьНачалоЭлемента("divide");
		// Определение имени типа.
		ИмяТипа 			= ИмяТипаИзЗначения(Граница.Значение); 
		ТипЗначенияГраницы 	= ТипЗнч(Граница.Значение);
		
		// Запись в строку вида границы.
		ИмяВидаГраницы = Строка(Граница.ВидГраницы);
		
		ФайлXML.ЗаписатьАтрибут("type", ИмяТипа);
		ФайлXML.ЗаписатьАтрибут("valueDiv", ИмяВидаГраницы);
		
		Если ТипЗначенияГраницы <> Тип("МоментВремени") Тогда 
			ФайлXML.ЗаписатьАтрибут("value", XMLСтрока(Граница.Значение));
		Иначе
			ЗаписатьМоментВремениВXML(ФайлXML, Граница.Значение);
		КонецЕсли;
	ФайлXML.ЗаписатьКонецЭлемента();
КонецПроцедуры	

// Возвращает строковое представление типа по значению.
//
// Параметры:
//	Значение - передаваемое значение.
//
Функция ИмяТипаИзЗначения(Значение) Экспорт
	Если ТипЗнч(Значение) = Тип("Строка") Тогда
		ИмяТипа = "Строка";
	ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда
		ИмяТипа = "Число";
	ИначеЕсли ТипЗнч(Значение) = Тип("Булево") Тогда
		ИмяТипа = "Булево";
	ИначеЕсли ТипЗнч(Значение) = Тип("Дата") Тогда
		ИмяТипа = "Дата";
	ИначеЕсли ТипЗнч(Значение) = Тип("МоментВремени") Тогда
		ИмяТипа = "МоментВремени";
	ИначеЕсли ТипЗнч(Значение) = Тип("Неопределено") Тогда
		ИмяТипа = "Строка";
	ИначеЕсли ТипЗнч(Значение) = Тип("ФиксированныйМассив") Тогда
		ИмяТипа = "ФиксированныйМассив";
	Иначе	
		ИмяТипа = xmlТип(ТипЗнч(Значение)).ИмяТипа;
	КонецЕсли;
	
	Возврат ИмяТипа;
КонецФункции

#КонецОбласти

#Область ОтладочныеМетоды

// Служебная. Показать произвольную выборку данных в отладчике
// Пример:
//	ОбщегоНазначенияУТ.ЗапросВыполнитьВыгрузить("выбрать * из Справочник.Валюты где Валюты.Код = &Код", Новый Структура("Код", "810"))
//
Функция ЗапросВыполнитьВыгрузить(ТекстЗапроса, ПараметрыЗапроса = Неопределено, МенеджерВременныхТаблиц = Неопределено) Экспорт
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Если МенеджерВременныхТаблиц <> Неопределено Тогда
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыЗапроса) Тогда
		Для Каждого Параметр Из ПараметрыЗапроса Цикл
			Запрос.УстановитьПараметр(Параметр.Ключ, Параметр.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Служебная. Показать временную таблицу из менеджера временных таблиц.
// Используется для просмотра временных таблиц в отладчике.
// Пример вызова функции:
//	ОбщегоНазначенияУТ.ПоказатьВременнуюТаблицу(Запрос, "ТаблицаТоваров")
//
Функция ПоказатьВременнуюТаблицу(МенеджерВременныхТаблицИлиЗапрос, ИмяВременнойТаблицы) Экспорт
	
	ЗакрытьМенеджерВременныхТаблиц = Ложь;
	
	Если ТипЗнч(МенеджерВременныхТаблицИлиЗапрос) = Тип("Запрос") Тогда
		Если МенеджерВременныхТаблицИлиЗапрос.МенеджерВременныхТаблиц = Неопределено Тогда
			МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
			ЗакрытьМенеджерВременныхТаблиц = Истина;
			МенеджерВременныхТаблицИлиЗапрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц; 
		Иначе
			МенеджерВременныхТаблиц = МенеджерВременныхТаблицИлиЗапрос.МенеджерВременныхТаблиц;
		КонецЕсли;
		МенеджерВременныхТаблицИлиЗапрос.Выполнить();
	Иначе
		МенеджерВременныхТаблиц = МенеджерВременныхТаблицИлиЗапрос;
	КонецЕсли; 
	
	ДанныеТаблицы = ЗапросВыполнитьВыгрузить("ВЫБРАТЬ * ИЗ " + ИмяВременнойТаблицы,, МенеджерВременныхТаблиц);
	
	Если ЗакрытьМенеджерВременныхТаблиц Тогда
		МенеджерВременныхТаблиц.Закрыть();
		МенеджерВременныхТаблицИлиЗапрос.МенеджерВременныхТаблиц = Неопределено;
	КонецЕсли; 
	
	Возврат ДанныеТаблицы;
	
КонецФункции

// Служебная. Преобразует таблицу значений в табличный документ и сохраняет его в файл.
// Примеры вызова функции:
// 	ОбщегоНазначенияУТ.СохранитьТаблицуЗначенийВФайл(Таблица, "c:\temp\таблица.mxl")
// 	ОбщегоНазначенияУТ.СохранитьТаблицуЗначенийВФайл(ОбщегоНазначенияУТ.ПоказатьВременнуюТаблицу(МВТ, "Таблица"), "c:\temp\таблица.mxl")
//
// Параметры:
//	Таблица - ТаблицаЗначений - произвольная таблица значений
//	ПолноеИмяФайла - Строка - полное имя сохраняемого файла, с расширением
//
// Возвращаемое значение:
//	Строка - текст сообщения об ошибке или пустая строка, если запись выполнена успешно.
//
Функция СохранитьТаблицуЗначенийВФайл(Таблица, ПолноеИмяФайла) Экспорт
	
	ВыгрузкаТаблицы = Новый ТабличныйДокумент; // преобразованная в mxl таблица значений
	
	НомерСтроки  = 1;
	НомерКолонки = 0;
	
	// Сформируем шапку табличного документа - выведем имена колонок таблицы значений
	Для Каждого ТекКолонка Из Таблица.Колонки Цикл
		
		НомерКолонки = НомерКолонки + 1;
		
		Область = ВыгрузкаТаблицы.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
		Область.Текст 		 = ТекКолонка.Имя;
		Область.Шрифт 		 = Новый Шрифт(Область.Шрифт,,, Истина); 
		Область.ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
		
	КонецЦикла;
	
	// Выведем строки таблицы значений
	Для Каждого ТекСтр Из Таблица Цикл
		
		НомерСтроки = НомерСтроки + 1;
		НомерКолонки = 0;
		
		Для Каждого ТекКолонка Из Таблица.Колонки Цикл
			
			НомерКолонки = НомерКолонки + 1;
			
			Область = ВыгрузкаТаблицы.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
			Область.Текст = ТекСтр[ТекКолонка.Имя];
			
		КонецЦикла;
		
	КонецЦикла;
	
	ВыгрузкаТаблицы.ФиксацияСверху = 1;
	ВыгрузкаТаблицы.ФиксацияСлева  = 1;
	
	// Сохраним табличный документ в файл
	ТекстОшибки = "";
	Попытка
		ВыгрузкаТаблицы.Записать(ПолноеИмяФайла);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	Возврат ТекстОшибки;
	
КонецФункции

#КонецОбласти
