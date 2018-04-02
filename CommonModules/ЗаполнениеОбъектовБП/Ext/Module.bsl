﻿
#Область ПрограммныйИнтерфейс

// Процедура предназначена для заполнения документов.
// Применяются следующие принципы:
// - всё что заполнено обработчиками в модуле объекта считается первичным и наиболее приоритетным.
// - остальное заполнение выполняется по цепочке, через структуру ДанныеЗаполнения.
// - каждая последующая процедура в цепочке дополняет структуру ДанныеЗаполнения,
// при этом, если указанный реквизит уже заполнен в ДокументОбъект, то в структуру
// ДанныеЗаполнения он не попадает.
// - по окончании выполнения цепочки ДокументОбъект заполняется данными из ДанныеЗаполнения.
//
// Параметры:
//  ДокументОбъект		 - ДокументОбъект - заполняемый документ.
//  ДанныеЗаполнения	 - Структура, ЛюбаяСсылка - значение, на основании
//                       которого выполняется заполнение документа.
//  СтратегияЗаполнения	 - Строка - имя процедуры обработчика заполнения
//                       в модуле объекта;
//                       - Соответствие - соответствие типов параметра
//                       ДанныеЗаполнения и имён обработчиков заполнения
//                       в модуле объекта.
//  ИсключаяСвойства	 - Строка - список имен свойств, разделенный запятыми,
//                       которые необходимо исключить из заполнения.
//
Процедура ЗаполнитьДокумент(ДокументОбъект, Знач ДанныеЗаполнения, Знач СтратегияЗаполнения = Неопределено, ИсключаяСвойства = "") Экспорт
	
	// КонтрольБазовойВерсии
	Если ВРег(Метаданные.Имя) = ВРег("БухгалтерияДляКыргызстанаБазовая") Тогда 
		Запрос = Новый Запрос();
		Запрос.Текст =
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Организации.Ссылка) КАК КоличествоОрганизаций
			|ИЗ
			|	Справочник.Организации КАК Организации";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.КоличествоОрганизаций > 1 Тогда
				ВызватьИсключение НСтр("ru='Ограничение базовой версии. В информационной базе может быть введена только одна организация.'");
				Прервать;
			КонецЕсли;
		КонецЦикла;
				
		МассивСоединений = ПолучитьСоединенияИнформационнойБазы();
		КоличествоСоединений = 0;
		Для Каждого Соединение Из МассивСоединений Цикл
			Если Соединение.ИмяПриложения <> "Designer" 
				И Соединение.ИмяПриложения <> "BackgroundJob" 
				И Соединение.ИмяПриложения <> "SystemBackgroundJob" Тогда
				КоличествоСоединений = КоличествоСоединений + 1;
			КонецЕсли;
			Если КоличествоСоединений > 1 Тогда
				ВызватьИсключение НСтр("ru = 'Ограничение базовой версии. Базовая версия не поддерживает одновременную работу нескольких пользователей.'");
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// Конец КонтрольБазовойВерсии
	
	Если ПропуститьЗаполнение(ДанныеЗаполнения) Тогда
		ЗаполнитьЗначенияСвойств(ДокументОбъект, ДанныеЗаполнения,, ИсключаяСвойства);
		Возврат;
	КонецЕсли;               	
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		ВызватьОбработчикПередЗаполнением(СтратегияЗаполнения, ДокументОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ВедомостьЗаработнойПлаты") Тогда
		СтратегияЗаполнения[Тип("Структура")] = "ЗаполнитьПоВедомостиЗП";
		ВызватьОбработчикПередЗаполнением(СтратегияЗаполнения, ДокументОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ВыплатаЗП") Тогда
		СтратегияЗаполнения[Тип("Структура")] = "ЗаполнитьПоВыплатеЗП";
		ВызватьОбработчикПередЗаполнением(СтратегияЗаполнения, ДокументОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ПреобразоватьДанныеЗаполненияСсылочногоТипаВСтруктуру(ДанныеЗаполнения, ДокументОбъект);
	ПреобразоватьЗначенияДанныхЗаполненияТипаМассивВСсылку(ДанныеЗаполнения);
	ДополнитьПериодРегистрации(ДанныеЗаполнения, ДокументОбъект);
	ДополнитьЗначениямиИзНастроек(ДанныеЗаполнения, ДокументОбъект);
	//ДополнитьПредопределеннымиЭлементамиСправочников(ДанныеЗаполнения, ДокументОбъект);
	РазыменоватьПоля(ДанныеЗаполнения, ДокументОбъект);
	
	ДанныеЗаполнения.Вставить("Автор", Пользователи.ТекущийПользователь());
	
	УдалитьНезаполненныеИсключаемыеСвойства(ДанныеЗаполнения, ИсключаяСвойства);
	ЗаполнитьЗначенияСвойств(ДокументОбъект, ДанныеЗаполнения,, ИсключаяСвойства);
	
	//ЗаполнитьТабличныеЧасти(ДокументОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура УдалитьНезаполненныеИсключаемыеСвойства(ДанныеЗаполнения, ИсключаяСвойства)
	
	Если ИсключаяСвойства="" Тогда
		Возврат;
	КонецЕсли;
	
	//Преобразуем строку ИсключаяСвойства в структуру
	СтруктураИсключаяСвойства = ОбщегоНазначенияБПСервер.СтрокаВСтруктуру(ИсключаяСвойства, ",");
	
	//Удалим из структуры ИсключаяСвойства те свойства, которых нет в ДанныеЗаполнения
	Для каждого ИмяСвойства Из СтруктураИсключаяСвойства Цикл
		Если НЕ ДанныеЗаполнения.Свойство(ИмяСвойства.Ключ) Тогда
			СтруктураИсключаяСвойства.Удалить(ИмяСвойства.Ключ);
	    КонецЕсли;
	КонецЦикла;
	
	//Преобразуем структуру ИсключаяСвойства обратно в строку с запятыми
	ИсключаяСвойства = ОбщегоНазначенияБПСервер.СтруктураВСтроку(СтруктураИсключаяСвойства, ",");
	
КонецПроцедуры

// Выполняет подстановку значений из заполненных элементов справочников,
// например, из значения Организация заполняются БанковскийСчет, Касса,
// Ответственные лица и НалогообложениеНДС, из значения Контрагент
// заполняется Договор, а из Договора - ВалютаРасчетов, ВидЦен,
// ВидЦенКонтрагента и ВидСкидкиНаценки.
//
// Параметры:
//  ДанныеЗаполнения - Структура - структура, которая будет дополнена разыменованными значениями.
//  ДокументОбъект	 - ДокументОбъект - заполняемый документ.
//
Процедура РазыменоватьПоля(ДанныеЗаполнения, ДокументОбъект) Экспорт
	
	РазыменованныеПоля = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ДанныеЗаполнения);
	
	УдалитьНезаполненныеЗначения(РазыменованныеПоля);
	
	РазыменоватьПоляОрганизации(РазыменованныеПоля, ДокументОбъект);
	ПроверитьВалюту(ДанныеЗаполнения, РазыменованныеПоля);
	РазыменоватьПоляВалюты(РазыменованныеПоля);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ДанныеЗаполнения, РазыменованныеПоля, Истина);
	
КонецПроцедуры

Процедура ПроверитьВалюту(ДанныеЗаполнения, РазыменованныеПоля)
	
	Если Не РазыменованныеПоля.Свойство("ВалютаДокумента") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ВалютаДокумента")
		И ДанныеЗаполнения.ВалютаДокумента = РазыменованныеПоля.ВалютаДокумента Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения.Удалить("ВалютаДокумента");
	
	Если ДанныеЗаполнения.Свойство("БанковскийСчет") Тогда
		ДанныеЗаполнения.Удалить("БанковскийСчет");
	КонецЕсли;
	
	Если РазыменованныеПоля.Свойство("БанковскийСчет") Тогда
		РазыменованныеПоля.Удалить("БанковскийСчет");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ЗаполнитьАвтораПриКопировании(Источник, ОбъектКопирования) Экспорт
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Автор", Пользователи.ТекущийПользователь());
	
	ЗаполнитьЗначенияСвойств(Источник, ДанныеЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПропуститьЗаполнение(ДанныеЗаполнения)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ДанныеЗаполнения.Свойство("ПропуститьЗаполнение") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения.ПропуститьЗаполнение) = Тип("Булево") Тогда
		Возврат ДанныеЗаполнения.ПропуститьЗаполнение;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Выбирает обработчик заполнения на основе переданного
// параметра СтратегияЗаполнения, затем вызывает
// этот обработчик из модуля объекта ДокументОбъект.
//
// Параметры:
//  СтратегияЗаполнения	 - Строка - имя процедуры обработчика заполнения
//                       в модуле объекта;
//                       - Соответствие - соответствие типов параметра
//                       ДанныеЗаполнения и имён обработчиков заполнения
//                       в модуле объекта.
//  ДокументОбъект		 - ДокументОбъект - заполняемый документ.
//  ДанныеЗаполнения	 - Структура, ЛюбаяСсылка - значение, на основании
//                       которого выполняется заполнение документа.
//
Процедура ВызватьОбработчикПередЗаполнением(СтратегияЗаполнения, ДокументОбъект, ДанныеЗаполнения)
	
	Если Не ЗначениеЗаполнено(СтратегияЗаполнения) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(СтратегияЗаполнения) = Тип("Строка") Тогда
		РаботаВБезопасномРежиме.ВыполнитьМетодОбъекта(
		ДокументОбъект,
		СтратегияЗаполнения,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеЗаполнения));
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(СтратегияЗаполнения) <> Тип("Соответствие") Тогда
		ВызватьИсключение НСтр("ru = 'Некорректный тип параметра ""ОбработчикЗаполнения"": ожидается Строка или Соответствие.'");
	КонецЕсли;
	
	ИмяОбработчикаПередЗаполнением = СтратегияЗаполнения[ТипЗнч(ДанныеЗаполнения)];
	
	Если Не ЗначениеЗаполнено(ИмяОбработчикаПередЗаполнением) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаВБезопасномРежиме.ВыполнитьМетодОбъекта(
	ДокументОбъект,
	ИмяОбработчикаПередЗаполнением,
	ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеЗаполнения));
	
КонецПроцедуры

// В случае когда в ДанныеЗаполнения передано значение ссылочного типа,
// преобразует ДанныеЗаполнения в Структуру.
// Если заполняемый документ ещё не содержит значения, переданного
// в параметре ДанныеЗаполнения, указанное значение будет помещено
// в структуру ДанныеЗаполнения.
//
// Параметры:
//  ДанныеЗаполнения	 - Произвольный - значение, на основании котрого
//                       выполняется заполнение документа.
//  ДокументОбъект		 - ДокументОбъект - заполняемый документ.
//
Процедура ПреобразоватьДанныеЗаполненияСсылочногоТипаВСтруктуру(ДанныеЗаполнения, ДокументОбъект)
	
	Если Не ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		ДанныеЗаполнения = Новый Структура;
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЗначениеСсылочногоТипа(ДанныеЗаполнения) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрОснование = ДанныеЗаполнения;
	ДанныеЗаполнения = Новый Структура;
	
	Для Каждого ИмяРеквизита Из ИменаРеквизитов(ПараметрОснование, ДокументОбъект) Цикл
		
		Если ЗначениеЗаполнено(ДокументОбъект[ИмяРеквизита]) Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеЗаполнения.Вставить(ИмяРеквизита, ПараметрОснование);
		
	КонецЦикла;
	
КонецПроцедуры

// В целях заполнения документов значениями из отбора преобразует все значения типа Массив
// в структуре ДанныеЗаполнения в одиночные значения, устанавливая в соответствющий ключ 
// последний элемент массива.
// 
// Параметры:
//  ДанныеЗаполнения - Структура.
//
Процедура ПреобразоватьЗначенияДанныхЗаполненияТипаМассивВСсылку(ДанныеЗаполнения)
	
	Для Каждого КлючИЗначение Из ДанныеЗаполнения Цикл
		
		Если ТипЗнч(КлючИЗначение.Значение) <> Тип("Массив") Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			Продолжить;
		КонецЕсли;
		
		ПоследнийЭлементМассива = КлючИЗначение.Значение[КлючИЗначение.Значение.ВГраница()];
		
		Если ТипЗнч(ПоследнийЭлементМассива) = Тип("Структура") Тогда
			// Здесь считаем, что это заполнение табличной части, пропускаем преобразование.
			Продолжить;
		КонецЕсли;
		
		ДанныеЗаполнения.Вставить(КлючИЗначение.Ключ, ПоследнийЭлементМассива);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДополнитьПериодРегистрации(ДанныеЗаполнения, ДокументОбъект)
	
	Если ДанныеЗаполнения.Свойство("ПериодРегистрации") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтсутствуетНезаполненныйРеквизит("ПериодРегистрации", ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения.Вставить("ПериодРегистрации", НачалоМесяца(ТекущаяДатаСеанса()));
	
КонецПроцедуры

// Выполняет подстановку значений из настроек.
//
// Параметры:
//  ДанныеЗаполнения - Структура - структура, которая будет дополнена значениями из настроек.
//  ДокументОбъект	 - ДокументОбъект - заполняемый документ.
//
Процедура ДополнитьЗначениямиИзНастроек(ДанныеЗаполнения, ДокументОбъект)
	
	ЗначенияИзНастроек = Новый Структура;
	
	ДополнитьОрганизация(ЗначенияИзНастроек, ДокументОбъект);
	ДополнитьВалюты(ЗначенияИзНастроек, ДокументОбъект);
	ДополнитьПодразделение(ЗначенияИзНастроек, ДокументОбъект);
	ДополнитьСклад(ЗначенияИзНастроек, ДокументОбъект);
	ДополнитьОсновнойТипПоставки(ЗначенияИзНастроек, ДокументОбъект);
	ДополнитьОсновнойВидПлатежа(ЗначенияИзНастроек, ДокументОбъект);
	ДополнитьЗначениямиУчетнойПолитики(ЗначенияИзНастроек, ДокументОбъект);
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ДанныеЗаполнения, ЗначенияИзНастроек, Ложь);
	
КонецПроцедуры

Функция ОтсутствуетНезаполненныйРеквизит(ИмяРеквизита, ДокументОбъект)
	
	Если Не ОбщегоНазначения.ЕстьРеквизитОбъекта(
		ИмяРеквизита,
		ДокументОбъект.Метаданные()) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(ДокументОбъект[ИмяРеквизита]);
	
КонецФункции

Процедура УдалитьНезаполненныеЗначения(РазыменованныеПоля)
	
	Для Каждого КлючИЗначение Из РазыменованныеПоля Цикл
		Если ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			Продолжить;
		КонецЕсли;
		РазыменованныеПоля.Удалить(КлючИЗначение.Ключ);
	КонецЦикла;

КонецПроцедуры

// Возвращает имена всех реквизитов документа, тип которых соответствуют
// типу указанного параметра Значение.
//
// Параметры:
//  Значение					 - Произвольный
//  ДокументОбъект				 - ДокументОбъект
// 
// Возвращаемое значение:
//  Массив - массив строк - имен реквизитов документа.
//
Функция ИменаРеквизитов(Значение, ДокументОбъект)
	
	Результат = Новый Массив;
	
	Для Каждого Реквизит Из ДокументОбъект.Ссылка.Метаданные().Реквизиты Цикл
		
		Если Реквизит.Тип.СодержитТип(ТипЗнч(Значение)) Тогда
			Результат.Добавить(Реквизит.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ДополнитьЗначениямиИзНастроек

Процедура ДополнитьОрганизация(ЗначенияИзНастроек, ДокументОбъект)
	
	Если ОтсутствуетНезаполненныйРеквизит("Организация", ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияПоУмолчанию = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		Пользователи.ТекущийПользователь(), 
		"ОсновнаяОрганизация");
	
	Если ЗначениеЗаполнено(ОрганизацияПоУмолчанию) Тогда
		ЗначенияИзНастроек.Вставить("Организация", ОрганизацияПоУмолчанию);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьВалюты(ЗначенияИзНастроек, ДокументОбъект) Экспорт
	
	ВалютаПоУмолчанию = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Для Каждого ИмяРеквизита Из ИменаРеквизитов(ВалютаПоУмолчанию, ДокументОбъект) Цикл
		
		Если ЗначенияИзНастроек.Свойство(ИмяРеквизита) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДокументОбъект[ИмяРеквизита]) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначенияИзНастроек.Вставить(ИмяРеквизита, ВалютаПоУмолчанию);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДополнитьПодразделение(ЗначенияИзНастроек, ДокументОбъект)
	
	Если ОтсутствуетНезаполненныйРеквизит("Подразделение", ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОсновноеПодразделение = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		Пользователи.ТекущийПользователь(), 
		"ОсновноеПодразделениеОрганизаций");
	
	Если ЗначениеЗаполнено(ОсновноеПодразделение) Тогда
		ЗначенияИзНастроек.Вставить("Подразделение", ОсновноеПодразделение);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьСклад(ЗначенияИзНастроек, ДокументОбъект)
	
	Если ОтсутствуетНезаполненныйРеквизит("Склад", ДокументОбъект)
		И ОтсутствуетНезаполненныйРеквизит("СкладОтправитель", ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойСклад = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		Пользователи.ТекущийПользователь(), 
		"ОсновнойСклад");
	
	Если ЗначениеЗаполнено(ОсновнойСклад) Тогда
		ЗначенияИзНастроек.Вставить("Склад", ОсновнойСклад);
		ЗначенияИзНастроек.Вставить("СкладОтправитель", ОсновнойСклад);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьОсновнойТипПоставки(ЗначенияИзНастроек, ДокументОбъект)
	
	Если ОтсутствуетНезаполненныйРеквизит("ТипПоставкиСФ", ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойТипПоставки = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		Пользователи.ТекущийПользователь(), 
		"ОсновнойТипПоставки");
	
	Если ЗначениеЗаполнено(ОсновнойТипПоставки) Тогда
		ЗначенияИзНастроек.Вставить("ТипПоставкиСФ", ОсновнойТипПоставки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьОсновнойВидПлатежа(ЗначенияИзНастроек, ДокументОбъект)
	
	Если ОтсутствуетНезаполненныйРеквизит("ВидПлатежа", ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОсновнойВидПлатежа = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		Пользователи.ТекущийПользователь(), 
		"ОсновнойВидПлатежа");
	
	Если ЗначениеЗаполнено(ОсновнойВидПлатежа) Тогда
		ЗначенияИзНастроек.Вставить("ВидПлатежа", ОсновнойВидПлатежа);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДополнитьЗначениямиУчетнойПолитики(ЗначенияИзНастроек, ДокументОбъект)
	
	Если НЕ ЗначенияИзНастроек.Свойство("Организация") Тогда 
		Возврат;
	КонецЕсли;	
	
	ТекущаяДата = ТекущаяДатаСеанса();
	ДанныеУчетнойПолитики = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиОрганизаций(ТекущаяДата, ЗначенияИзНастроек.Организация);
	
	// Ставка НСП (товары).
	Если НЕ ОтсутствуетНезаполненныйРеквизит("СтавкаНСП", ДокументОбъект) Тогда
		СтавкаНСПРеализацииТовары = ДанныеУчетнойПолитики.СтавкаНСПРеализацииТовары;
		Если ЗначениеЗаполнено(СтавкаНСПРеализацииТовары) Тогда
			ЗначенияИзНастроек.Вставить("СтавкаНСП", СтавкаНСПРеализацииТовары);				
		КонецЕсли;				
	КонецЕсли;
	
	// Ставка НСП (услуги).
	Если НЕ ОтсутствуетНезаполненныйРеквизит("СтавкаНСПУслуги", ДокументОбъект) Тогда
		СтавкаНСПРеализацииУслуги = ДанныеУчетнойПолитики.СтавкаНСПРеализацииУслуги;
		Если ЗначениеЗаполнено(СтавкаНСПРеализацииУслуги) Тогда
			ЗначенияИзНастроек.Вставить("СтавкаНСПУслуги", СтавкаНСПРеализацииУслуги);				
		КонецЕсли;				
	КонецЕсли;

КонецПроцедуры	

#КонецОбласти

#Область РазыменоватьПоля

Процедура РазыменоватьПоляОрганизации(РазыменованныеПоля, ДокументОбъект)
	
	Если Не ОбщегоНазначения.ЕстьРеквизитОбъекта(
		"Организация",
		ДокументОбъект.Метаданные()) Тогда
		Возврат;
	КонецЕсли;
	
	Организация = ДокументОбъект.Организация;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		РазыменованныеПоля.Свойство("Организация", Организация);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат;
	КонецЕсли;
	
	РазыменоватьПоляОрганизацииБанковскийСчет(РазыменованныеПоля, ДокументОбъект, Организация);
	РазыменоватьПоляОрганизацииКасса(РазыменованныеПоля, ДокументОбъект, Организация);
	
КонецПроцедуры

Процедура РазыменоватьПоляОрганизацииБанковскийСчет(РазыменованныеПоля, ДокументОбъект, Организация)
	
	Если ОтсутствуетНезаполненныйРеквизит("БанковскийСчет", ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", ДокументОбъект.Метаданные())
		И ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента) Тогда
		ВалютаДокумента = ДокументОбъект.ВалютаДокумента;
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", ДокументОбъект.Метаданные())
		И ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента) Тогда
		ВалютаДокумента = ДокументОбъект.ВалютаДокумента;
	Иначе 
		ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		РазыменованныеПоля.Свойство("ВалютаДокумента", ВалютаДокумента);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		РазыменованныеПоля.Свойство("ВалютаДокумента", ВалютаДокумента);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА Организации.ОсновнойБанковскийСчет.ВалютаДенежныхСредств = &ВалютаДокумента
		|			ТОГДА Организации.ОсновнойБанковскийСчет
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК БанковскийСчет
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Организация");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Если Не ЗначениеЗаполнено(Выборка.БанковскийСчет) Тогда
		Возврат;
	КонецЕсли;
	
	РазыменованныеПоля.Вставить("БанковскийСчет", Выборка.БанковскийСчет);
	
КонецПроцедуры

Процедура РазыменоватьПоляОрганизацииКасса(РазыменованныеПоля, ДокументОбъект, Организация)
	
	Если ОтсутствуетНезаполненныйРеквизит("Касса", ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", ДокументОбъект.Метаданные())
		И ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента) Тогда
		ВалютаДокумента = ДокументОбъект.ВалютаДокумента;
	ИначеЕсли ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", ДокументОбъект.Метаданные())
		И ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента) Тогда
		ВалютаДокумента = ДокументОбъект.ВалютаДокумента;
	Иначе 
		ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		РазыменованныеПоля.Свойство("ВалютаДокумента", ВалютаДокумента);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		РазыменованныеПоля.Свойство("ВалютаДокумента", ВалютаДокумента);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА Организации.ОсновнаяКасса.ВалютаДенежныхСредств = &ВалютаДокумента
		|			ТОГДА Организации.ОсновнаяКасса
		|		ИНАЧЕ НЕОПРЕДЕЛЕНО
		|	КОНЕЦ КАК Касса
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Организация");
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Если Не ЗначениеЗаполнено(Выборка.Касса) Тогда
		Возврат;
	КонецЕсли;
	
	РазыменованныеПоля.Вставить("Касса", Выборка.Касса);
	
КонецПроцедуры

Процедура РазыменоватьПоляВалюты(РазыменованныеПоля)
	
	Для Каждого КлючИЗначение Из РазыменованныеПоля Цикл
		
		Если ТипЗнч(КлючИЗначение.Значение) <> Тип("СправочникСсылка.Валюты") Тогда
			Продолжить;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(
		РазыменованныеПоля,
		РегистрыСведений.КурсыВалют.ПолучитьПоследнее(,
		Новый Структура("Валюта", КлючИЗначение.Значение)),
		Истина);
		
		Прервать;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеДокументов

// Определяет курс документа, который равен либо курсу документа (если в документе он существует),
// либо курсу взаиморасчетов, либо 1.
//
// Параметры:
//  ДокументОбъект - ДокументОбъект - Объект документа, курс которого надо получить.
//  ВалютаРегламентированногоУчета - СправочникСсылка.Валюты - Валюта регламентированного учета.
//
// Возвращаемое значение:
//  Число - курс документа.
//
Функция Курс(ДокументОбъект, ВалютаРегламентированногоУчета) Экспорт

	МетаданныеДокумента = ДокументОбъект.Ссылка.Метаданные();

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", МетаданныеДокумента) Тогда
		// Если валюта документа совпадает с валютой регл. учета, то курс 1.
		Если (ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента)) И (ДокументОбъект.ВалютаДокумента <> ВалютаРегламентированногоУчета) Тогда

			МетаданныеДокумента = ДокументОбъект.Ссылка.Метаданные();

			// Если есть реквизит Курс - его и вернем
			Если ТипЗнч(ДокументОбъект) = Тип("Структура") И ДокументОбъект.Свойство("Курс")
				ИЛИ ТипЗнч(ДокументОбъект) <> Тип("Структура") И ОбщегоНазначения.ЕстьРеквизитОбъекта("Курс", МетаданныеДокумента) Тогда
				Возврат ДокументОбъект.Курс;
			КонецЕсли;

			// Если нет Курс и валюта документа не совпадает с валютой регл. учета,
			// то такой документ может быть выписан только в валюте взаиморасчетов,
			// если есть реквизит КурсВзаиморасчетов - его и вернем.
			Если ТипЗнч(ДокументОбъект) = Тип("Структура") И ДокументОбъект.Свойство("КурсВзаиморасчетов")
				ИЛИ ТипЗнч(ДокументОбъект) <> Тип("Структура") И ОбщегоНазначения.ЕстьРеквизитОбъекта("КурсВзаиморасчетов", МетаданныеДокумента) Тогда
				Возврат ДокументОбъект.КурсВзаиморасчетов;
			КонецЕсли;

			// Если нет КурсВзаиморасчетов и валюта документа не совпадает с валютой регл. учета,
			// то КурсВзаиморасчетов должен быть в табличной части документа или может вообще отсутствовать.
			// Тогда возьмем курс из справочника на дату документа.
			Возврат РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДокументОбъект.ВалютаДокумента,ДокументОбъект.Дата).Курс;

		КонецЕсли;
	КонецЕсли;

	Возврат 1;

КонецФункции

// Определяет кратность документа, которая равен либо кратности документа (если в документе она существует),
// либо кратности взаиморасчетов, либо 1.
//
// Параметры:
//  ДокументОбъект - ДокументОбъект - Объект документа, курс которого надо получить.
//  ВалютаРегламентированногоУчета - СправочникСсылка.Валюты - Валюта регламентированного учета.
//
// Возвращаемое значение:
//  Число - кратность валюты в документе.
//
Функция Кратность(ДокументОбъект, ВалютаРегламентированногоУчета) Экспорт

	МетаданныеДокумента = ДокументОбъект.Ссылка.Метаданные();

	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВалютаДокумента", МетаданныеДокумента) Тогда
		// Если валюта документа совпадает с валютой регл. учета, то кратность 1.
		Если (ЗначениеЗаполнено(ДокументОбъект.ВалютаДокумента)) И (ДокументОбъект.ВалютаДокумента <> ВалютаРегламентированногоУчета) Тогда

			// Если есть реквизит Кратность - его и вернем
			Если ТипЗнч(ДокументОбъект) = Тип("Структура") И ДокументОбъект.Свойство("Кратность")
				ИЛИ ТипЗнч(ДокументОбъект) <> Тип("Структура") И ОбщегоНазначения.ЕстьРеквизитОбъекта("Кратность", МетаданныеДокумента) Тогда
				Возврат ДокументОбъект.Кратность;
			КонецЕсли;

			// Если нет Кратность и валюта документа не совпадает с валютой регл. учета,
			// то такой документ может быть выписан только в валюте взаиморасчетов,
			// если есть реквизит КратностьВзаиморасчетов - его и вернем.
			Если ТипЗнч(ДокументОбъект) = Тип("Структура") И ДокументОбъект.Свойство("КратностьВзаиморасчетов")
				ИЛИ ТипЗнч(ДокументОбъект) <> Тип("Структура") И ОбщегоНазначения.ЕстьРеквизитОбъекта("КратностьВзаиморасчетов", МетаданныеДокумента) Тогда
				Возврат ДокументОбъект.КратностьВзаиморасчетов;
			КонецЕсли;

			// Если нет КратностьВзаиморасчетов и валюта документа не совпадает с валютой регл. учета,
			// то КратностьВзаиморасчетов должна быть в табличной части документа или может вообще отсутствовать.
			//Тогда возьмем Кратность из справочника на дату документа.
			Возврат РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДокументОбъект.ВалютаДокумента,ДокументОбъект.Дата).Кратность;

		КонецЕсли;
    КонецЕсли;

	Возврат 1;

КонецФункции

#КонецОбласти
