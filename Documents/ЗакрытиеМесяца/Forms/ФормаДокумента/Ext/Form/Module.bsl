﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
	
	БазаРаспределенияКорректировкиСебестоимости = Константы.БазаРаспределенияКорректировкиСебестоимости.Получить();
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	УстановитьФункциональныеОпцииФормы();

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	УстановитьУсловноеОформление();

	// РаботаСФормами
	РаботаСФормамиСервер.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец РаботаСФормами
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменений
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменений
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПроизведеноЗакрытиеМесяца" Тогда  
		ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчета.ПослеЗаписиНаСервере(ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Объект.Дата = КонецМесяца(Объект.Дата);

	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		
		Объект.Дата = КонецМесяца(Объект.Дата);
		
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;		
		
	КонецЕсли;
	
	Если Месяц(Объект.Дата) <> 12 Тогда
		Объект.РасчетНалогаНаПрибыль = Ложь;
	КонецЕсли;
	
	БухгалтерскийУчетВызовСервераПовтИсп.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
	
	УстановитьФункциональныеОпцииФормы();
	СнятьПометки(Элементы.СнятьПометки);	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервераПовтИсп.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	ДанныеУчетнойПолитики = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьДанныеУчетнойПолитикиОрганизаций(ДатаДокумента, Объект.Организация);
	
	УстановитьФункциональныеОпцииФормы();
	СнятьПометки(Элементы.СнятьПометки);	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
КонецПроцедуры  

// Процедура - обработчик события НачалоВыбора поля ввода Комментарий.
//
&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасчетАмортизацииОС.
//
&НаКлиенте
Процедура РасчетАмортизацииОСПриИзменении(Элемент)
	Если НЕ Объект.РасчетАмортизацииОС Тогда
		Объект.АмортизацияОС.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасчетПереоценкиВалютныхСредств.
//
&НаКлиенте
Процедура РасчетПереоценкиВалютныхСредствПриИзменении(Элемент)
	Если НЕ Объект.РасчетПереоценкиВалютныхСредств Тогда
		Объект.ПереоценкаВалюты.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасчетНДС.
//
&НаКлиенте
Процедура РасчетНДСПриИзменении(Элемент)
	Если НЕ Объект.РасчетНДС Тогда
		Объект.НДС.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасчетНалогаНаИмущество.
//
&НаКлиенте
Процедура РасчетНалогаНаИмуществоПриИзменении(Элемент)
	Если НЕ Объект.РасчетНалогаНаИмущество Тогда
		Объект.Транспорт.Очистить();
		Объект.Недвижимость.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасчетНалогаНаПрибыль.
//
&НаКлиенте
Процедура РасчетНалогаНаПрибыльПриИзменении(Элемент)
	Если НЕ Объект.РасчетНалогаНаПрибыль Тогда
		Объект.НалоговаяАмортизация.Очистить();
		Объект.НалоговаяВыверка.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасчетЕдиногоНалога.
//
&НаКлиенте
Процедура РасчетЕдиногоНалогаПриИзменении(Элемент)
	Если НЕ Объект.РасчетЕдиногоНалога Тогда
		Объект.ЕдиныйНалог.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ЗакрытьПарныеСчетаУчета.
//
&НаКлиенте
Процедура ЗакрытьПарныеСчетаУчетаПриИзменении(Элемент)
	Если НЕ Объект.ЗакрытьПарныеСчетаУчета Тогда
		Объект.ПарныеСчетаУчета.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ЗакрытьВременныеСчетаУчета.
//
&НаКлиенте
Процедура ЗакрытьВременныеСчетаУчетаПриИзменении(Элемент)
	Если НЕ Объект.ЗакрытьВременныеСчетаУчета Тогда
		Объект.ВременныеСчетаУчета.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасчетНераспределеннойПрибыли.
//
&НаКлиенте
Процедура РасчетНераспределеннойПрибылиПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасчетСписанияРасходовБудущихПериодов.
//
&НаКлиенте
Процедура РасчетСписанияРасходовБудущихПериодовПриИзменении(Элемент)
	Если НЕ Объект.РасчетСписанияРасходовБудущихПериодов Тогда
		Объект.РасходыБП.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура РасчетСтоимостиПродукцииПоНоменклатурнымГруппамПриИзменении(Элемент)
	Если НЕ Объект.РасчетСтоимостиПродукцииПоНоменклатурнымГруппам Тогда
		Объект.НакладныеРасходы.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода РасчетСтоимостиПродукцииПоЗаказам.
//
&НаКлиенте
Процедура РасчетСтоимостиПродукцииПоЗаказамПриИзменении(Элемент)
	Если НЕ Объект.РасчетСтоимостиПродукцииПоЗаказам Тогда
		Объект.РасходыНаПроизводство.Очистить();
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьЗакрытиеМесяца(Команда)
	
	УчетнаяПолитикаСуществует = БухгалтерскийУчетВызовСервераПовтИсп.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	
	Если НЕ ЗаписатьДокументОтменивПроведение() ИЛИ НЕ УчетнаяПолитикаСуществует Тогда 
		Возврат;
	КонецЕсли;	
	
	Если Объект.РасчетЕдиногоНалога Тогда
		Если КонецМесяца(Объект.Дата) = КонецКвартала(Объект.Дата) Тогда
			
			Если НЕ ЕдиныйНалогРассчитанПравильно() Тогда
				ТекстСообщения = НСтр("ru = 'По единому налогу рассчитаны не все предыдущие месяцы. Заполнение документа отменено.'");
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);		
				Возврат;
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;
	
	Если Объект.РасчетСтоимостиПродукцииПоНоменклатурнымГруппам 
		И НЕ ЗначениеЗаполнено(БазаРаспределенияКорректировкиСебестоимости) Тогда 
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(,, НСтр("ru = 'База распределения корректировки себестоимости'"));
		ТекстСообщения = ТекстСообщения + "
			|Закройте документ, в настройках ""Параметры учета"" - Раздел ""Производство"" - ""Настройки учета производства"" - поле ""База распределения корректировки себестоимости"" укажите базу распределения корректировки себестоимости и затем повторите попытку.";
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Объект.Организация");
		Возврат;		
	КонецЕсли;	
	
	ВыполнитьЗакрытиеМесяцаНаКлиенте();
	
	//ДлительнаяОперация = ВыполнитьЗакрытиеМесяцаВФоне();
	//ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	//ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	//ПараметрыОжидания.ВыводитьСообщения = Истина;
	//
	//// Прогресс.
	//ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
	//ПараметрыОжидания.Интервал  = 2;
	//
	//ОповещениеОЗавершении = Новый ОписаниеОповещения("ВыполнитьЗакрытиеМесяцаВФонеЗавершение", ЭтотОбъект);
	//ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсе(Команда)
	
	Объект.РасчетАмортизацииОС		 						= Истина;
	Объект.РасчетПереоценкиВалютныхСредств 					= Истина;
	Объект.РасчетНДС		 								= ДанныеУчетнойПолитики.ПлательщикНДС;
	Объект.ЗакрытьПарныеСчетаУчета 							= Истина;
	Объект.ЗакрытьВременныеСчетаУчета 						= Истина;
	Объект.РасчетНераспределеннойПрибыли 					= Истина;
	Объект.РасчетСтоимостиПродукцииПоЗаказам 				= ПолучитьФункциональнуюОпциюНаСервере("УчетПроизводстваПоЗаказам");
	Объект.РасчетСписанияРасходовБудущихПериодов 			= Истина;
	Объект.РасчетНалогаНаИмущество 							= Истина;
	Объект.РасчетСтоимостиПродукцииПоНоменклатурнымГруппам 	= ПолучитьФункциональнуюОпциюНаСервере("УчетПроизводстваПоНоменклатурнымГруппам");
	Объект.РасчетЕдиногоНалога								= ДанныеУчетнойПолитики.ПлательщикЕН;
	
	Если Месяц(Объект.Дата) = 12 Тогда
		Объект.РасчетНалогаНаПрибыль = Истина;
	КонецЕсли;	
	
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)
	Объект.РасчетАмортизацииОС 							 	= Ложь;
	Объект.РасчетПереоценкиВалютныхСредств		 		 	= Ложь;
	Объект.РасчетНДС 									 	= Ложь;
	Объект.РасчетНалогаНаИмущество 						 	= Ложь;
	Объект.ЗакрытьПарныеСчетаУчета		 				 	= Ложь;
	Объект.ЗакрытьВременныеСчетаУчета 					 	= Ложь;
	Объект.РасчетНераспределеннойПрибыли		 		 	= Ложь;
	Объект.РасчетНалогаНаПрибыль 				 			= Ложь;
	Объект.РасчетСтоимостиПродукцииПоЗаказам 			 	= Ложь;
	Объект.РасчетСписанияРасходовБудущихПериодов		 	= Ложь;
	Объект.РасчетСтоимостиПродукцииПоНоменклатурнымГруппам	= Ложь;
	Объект.РасчетЕдиногоНалога								= Ложь;
	
	Объект.АмортизацияОС.Очистить();
	Объект.Недвижимость.Очистить();
	Объект.Транспорт.Очистить();
	Объект.ПереоценкаВалюты.Очистить();
	Объект.АвансыИДоотгрузка.Очистить();
	Объект.АвансыРасшифровка.Очистить();
	Объект.ДоотгрузкаРасшифровка.Очистить();
	Объект.НДС.Очистить();
	Объект.ПарныеСчетаУчета.Очистить();
	Объект.ВременныеСчетаУчета.Очистить();
	Объект.РасходыНаПроизводство.Очистить();
	Объект.НакладныеРасходы.Очистить();
	Объект.НалоговаяАмортизация.Очистить();
	Объект.НалоговаяВыверка.Очистить();
	Объект.РасходыБП.Очистить();
	Объект.КорректировкаНДС.Очистить();
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ПарныеСчетаУчетаПодробно(Команда)
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПарныеСчетаУчетаПодробно",
		"Пометка",
		Не Элементы.ПарныеСчетаУчетаПодробно.Пометка);

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМониторОС(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДатаНачала", 		НачалоМесяца(Объект.Дата));
	ПараметрыФормы.Вставить("ДатаОкончания", 	КонецМесяца(Объект.Дата));
	ПараметрыФормы.Вставить("Организация", 		Объект.Организация);
					
	ОткрытьФорму("Обработка.МониторОС.Форма.ОсновнаяФорма",ПараметрыФормы);	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМониторРасчетов(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ДатаНачала", 		НачалоМесяца(Объект.Дата));
	ПараметрыФормы.Вставить("ДатаОкончания", 	КонецМесяца(Объект.Дата));
	ПараметрыФормы.Вставить("Организация", 		Объект.Организация);
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаНДС Тогда
		ПараметрыФормы.Вставить("ПерейтиНаАвансы", Истина);
	Иначе
		ПараметрыФормы.Вставить("ПерейтиНаАвансы", Ложь);
	КонецЕсли;	
		
	ОткрытьФорму("Обработка.МониторРасчетов.Форма.Форма",ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьМониторНДС(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Дата", 		Объект.Дата);
	ПараметрыФормы.Вставить("Организация", 	Объект.Организация);	
	
	ОткрытьФорму("Обработка.МониторНДС.Форма.Форма", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.СтраницаАмортизацияОС.Видимость 			= Объект.РасчетАмортизацииОС;						
	Элементы.СтраницаПереоценкаВалюты.Видимость 		= Объект.РасчетПереоценкиВалютныхСредств;			
	Элементы.СтраницаНДС.Видимость						= Объект.РасчетНДС;
	Элементы.СтраницаНалогНаИмущество.Видимость			= Объект.РасчетНалогаНаИмущество;
	Элементы.СтраницаПарныеСчетаУчета.Видимость			= Объект.ЗакрытьПарныеСчетаУчета;
	Элементы.СтраницаВременныеСчетаУчета.Видимость		= Объект.ЗакрытьВременныеСчетаУчета;
	Элементы.СтраницаРасходыБудущихПериодов.Видимость	= Объект.РасчетСписанияРасходовБудущихПериодов;
	Элементы.СтраницаПроизводство.Видимость				= Объект.РасчетСтоимостиПродукцииПоЗаказам Или Объект.РасчетСтоимостиПродукцииПоНоменклатурнымГруппам;
	Элементы.СтраницаНалогНаПрибыль.Видимость			= Объект.РасчетНалогаНаПрибыль;
	Элементы.СтраницаЕдиныйНалог.Видимость				= Объект.РасчетЕдиногоНалога;
	
	Если Месяц(Объект.Дата) <> 12 Тогда
		Элементы.РасчетНалогаНаПрибыль.Доступность = Ложь;
	Иначе
		Элементы.РасчетНалогаНаПрибыль.Доступность = Истина;
	КонецЕсли;	
	
	// Страница парные счета учета
	Элементы.ПарныеСчетаУчетаГруппаСальдо.Видимость 		= Элементы.ПарныеСчетаУчетаПодробно.Пометка;
	Элементы.ПарныеСчетаУчетаГруппаСальдоВалютное.Видимость = Элементы.ПарныеСчетаУчетаПодробно.Пометка;
	
	Если Элементы.ПарныеСчетаУчетаПодробно.Пометка Тогда 
		Элементы.ПарныеСчетаУчетаГруппаСчетаУчета.Группировка 	= ГруппировкаКолонок.Вертикальная;
		Элементы.ПарныеСчетаУчетаГруппаСубконто.Группировка 	= ГруппировкаКолонок.Вертикальная;
		Элементы.ПарныеСчетаУчетаГруппаСумма.Группировка 		= ГруппировкаКолонок.Вертикальная;
	Иначе 
		Элементы.ПарныеСчетаУчетаГруппаСчетаУчета.Группировка 	= ГруппировкаКолонок.Горизонтальная;
		Элементы.ПарныеСчетаУчетаГруппаСубконто.Группировка 	= ГруппировкаКолонок.Горизонтальная;
		Элементы.ПарныеСчетаУчетаГруппаСумма.Группировка 		= ГруппировкаКолонок.Горизонтальная;
	КонецЕсли;	
	
	Элементы.ПредельнаяНормаНаРемонтОС.Видимость = Ложь;
	Элементы.МинимальнаяСтоимостьГруппыОС.Видимость = Ложь;
	Элементы.НеФормироватьОтсроченныеПроводки.Видимость = Ложь;

	Если Объект.РасчетНалогаНаПрибыль Тогда 
		Элементы.ПредельнаяНормаНаРемонтОС.Видимость = Истина;
		Элементы.МинимальнаяСтоимостьГруппыОС.Видимость = Истина;
		Элементы.НеФормироватьОтсроченныеПроводки.Видимость = Истина;
	КонецЕсли;	
	
	Элементы.ГруппаПроизводствоПоЗаказам.Видимость = ПолучитьФункциональнуюОпцию("УчетПроизводстваПоЗаказам");
	Элементы.ГруппаПроизводствоПоНоменклатурнымГруппам.Видимость = ПолучитьФункциональнуюОпцию("УчетПроизводстваПоНоменклатурнымГруппам");
	
КонецПроцедуры 

// Процедура устанавливает функциональные опции формы документа.
//
&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма, Объект.Организация, ДатаДокумента);
КонецПроцедуры

// Функция - Получить функциональную опцию на сервере
//
// Параметры:
//  Имя	 - Строка - Имя функциональной опции в соответствии с установленными языковыми настройками.
//
&НаСервереБезКонтекста
Функция ПолучитьФункциональнуюОпциюНаСервере(Имя)
	Возврат ПолучитьФункциональнуюОпцию(Имя);
КонецФункции // ПолучитьФункциональнуюОпциюНаСервере()

&НаСервере
Функция ВыполнитьЗакрытиеМесяцаВФоне()
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Закрытие месяца ""%1""'"), Формат(ДатаДокумента, "ДЛФ=D"));

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НаименованиеФоновогоЗадания;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыПроцедуры.Вставить("РасчетЕдиногоНалогаЗаКвартал", РасчетЕдиногоНалогаЗаКвартал);
	
	Результат = ДлительныеОперации.ВыполнитьВФоне("Документы.ЗакрытиеМесяца.ВыполнитьЗакрытиеМесяца",
		ПараметрыПроцедуры, ПараметрыВыполнения);
		
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьЗакрытиеМесяцаНаКлиенте()

	Если НЕ ЗаписатьДокументОтменивПроведение() Тогда 
		Возврат;
	КонецЕсли;	

	// Предварительная очистка.
	Объект.АмортизацияОС.Очистить();
	Объект.Недвижимость.Очистить();
	Объект.Транспорт.Очистить();
	Объект.ПереоценкаВалюты.Очистить();
	Объект.АвансыИДоотгрузка.Очистить();
	Объект.АвансыРасшифровка.Очистить();
	Объект.ДоотгрузкаРасшифровка.Очистить();
	Объект.НДС.Очистить();
	Объект.ПарныеСчетаУчета.Очистить();
	Объект.ВременныеСчетаУчета.Очистить();
	Объект.РасходыНаПроизводство.Очистить();
	Объект.НакладныеРасходы.Очистить();
	Объект.НалоговаяАмортизация.Очистить();
	Объект.НалоговаяВыверка.Очистить();
	Объект.РасходыБП.Очистить();
	Объект.КорректировкаНДС.Очистить();
	Объект.ЕдиныйНалог.Очистить();
	
	Объект.СуммаГотоваяПродукцияПлановая = 0;
	Объект.СуммаГотоваяПродукцияКорректировка = 0;
	Объект.СуммаОбщехозяйственныхРасходов = 0;
	Объект.СуммаВспомогательногоПроизводства = 0;
	Объект.СуммаНалогНаПрибыль = 0;
	Объект.СуммаНалогНаПрибыльБУ = 0;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("Ошибки", Неопределено);
	ПараметрыПроцедуры.Вставить("Сообщения", Неопределено);
	ПараметрыПроцедуры.Вставить("РасчетЕдиногоНалогаЗаКвартал", РасчетЕдиногоНалогаЗаКвартал);

	ВыполнитьЗакрытиеМесяцаНаСервере(ПараметрыПроцедуры);
	
	ТекстОповещения = НСтр("ru = 'Выполнено закрытие месяца'");

	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ПараметрыПроцедуры.Ошибки);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ПараметрыПроцедуры.Сообщения);
	
	Если ПараметрыПроцедуры.Ошибки = Неопределено Тогда
		ПоказатьОповещениеПользователя(ТекстОповещения,, НСтр("ru = 'При расчете ошибок не обнаружено'"), БиблиотекаКартинок.Информация32);
	Иначе 
		ПоказатьОповещениеПользователя(ТекстОповещения,, НСтр("ru = 'При расчете возникли ошибки'"), БиблиотекаКартинок.Ошибка32);
	КонецЕсли;	
	
	Оповестить("ПроизведеноЗакрытиеМесяца");
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗакрытиеМесяцаНаСервере(ПараметрыПроцедуры)

	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ВыполнитьЗакрытиеМесяца(ПараметрыПроцедуры);
	ЗначениеВРеквизитФормы(Документ, "Объект");	
	Модифицированность = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗакрытиеМесяцаВФонеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Оповестить("ПроизведеноЗакрытиеМесяца");
	
	ДлительнаяОперация = Неопределено;

	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		ОбработатьУспешноеВыполнениеЗакрытиеМесяцаВФоне(Результат);
		
		ТекстОповещения = НСтр("ru = 'Выполнено закрытие месяца'");
		
		Если Объект.Проведен Тогда
			ПоказатьОповещениеПользователя(ТекстОповещения,, НСтр("ru = 'При расчете ошибок не обнаружено'"), БиблиотекаКартинок.Информация32);
		Иначе 
			ПоказатьОповещениеПользователя(ТекстОповещения,, НСтр("ru = 'При расчете возникли ошибки'"), БиблиотекаКартинок.Ошибка32);
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьУспешноеВыполнениеЗакрытиеМесяцаВФоне(Результат)
	
	// Итоговый результат
	Если ЭтоАдресВременногоХранилища(Результат.АдресРезультата) Тогда
		Ссылка = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		ЗначениеВРеквизитФормы(Ссылка.ПолучитьОбъект(), "Объект");
		Модифицированность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
КонецФункции

// Функция возвращает результат возможности записи/отмены проведения документа перед расчетом
//
// Параметры:
//  Действие - действие, при котором выполняется проверка
// Возвращаемое значение:
//   Булево - 
//
&НаКлиенте
Функция ЗаписатьДокументОтменивПроведение()
	Если Объект.Проведен Тогда
		ЗаписатьНаСервере(РежимЗаписиДокумента.ОтменаПроведения);		
	ИначеЕсли НЕ ЗначениеЗаполнено(Объект.Ссылка) Или Модифицированность Тогда 
		Объект.Дата = ДатаДокумента;
		ЗаписатьНаСервере(РежимЗаписиДокумента.Запись);		
	КонецЕсли;	
	
	Модифицированность = Ложь;

	Возврат НЕ Объект.Проведен И ЗначениеЗаполнено(Объект.Ссылка);
КонецФункции // ЗаписатьДокументОтменивПроведение()

// Процедура - Записать на сервере
//
// Параметры:
//  Режим	 - 	 - 
//
&НаСервере
Процедура ЗаписатьНаСервере(Режим)
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Записать(Режим);
	ЗначениеВРеквизитФормы(Документ, "Объект");
КонецПроцедуры // ЗаписатьНаСервере()

// Процедура настройки условного оформления форм и динамических списков .
//
&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Строка 069
	Элемент = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, "НДС");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор, "Объект.НДС.Строка", ВидСравненияКомпоновкиДанных.Содержит, "069");
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаРедактируемыхСтрокОтчетаНДС);
	
	// Строка 070
	Элемент = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, "НДС");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор, "Объект.НДС.Строка", ВидСравненияКомпоновкиДанных.Содержит, "070");
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаРедактируемыхСтрокОтчетаНДС);
	
	// Строка 071
	Элемент = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, "НДС");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор, "Объект.НДС.Строка", ВидСравненияКомпоновкиДанных.Содержит, "071");
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаРедактируемыхСтрокОтчетаНДС);
	
	// Строка 072
	Элемент = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, "НДС");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор, "Объект.НДС.Строка", ВидСравненияКомпоновкиДанных.Содержит, "072");
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаРедактируемыхСтрокОтчетаНДС);
	
	// Таблица ДоотгрузкаРасшифровка.
	Элемент = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, "ДоотгрузкаРасшифровка");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор, "Объект.ДоотгрузкаРасшифровка.Сумма", ВидСравненияКомпоновкиДанных.Равно, 0);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ДобавленныйРеквизитФон);
	
	// Таблица АвансыРасшифровка.
	Элемент = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, "АвансыРасшифровка");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор, "Объект.АвансыРасшифровка.СуммаДокумента", ВидСравненияКомпоновкиДанных.Равно, 0);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ДобавленныйРеквизитФон);
	
	// Таблица АвансыРасшифровка.
	Элемент = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, "АвансыРасшифровкаКонтрагент");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, "АвансыРасшифровкаДоговор");
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор, "Объект.АвансыРасшифровка.СуммаДокумента", ВидСравненияКомпоновкиДанных.НеРавно, 0);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЦвет);
	
КонецПроцедуры

// Функция проверки заполнения единого налога в предыдущих закрытиях месяца
// за определенный квартал и возврата периода в случае правильности заполнения. 
//
// Параметры:
//	Отказ - Булево - признак ошибки заполнения единого налога в предыдущих док. "Закрытие месяца".
//
&НаСервере
Функция ЕдиныйНалогРассчитанПравильно()

	НачалоПериода = НачалоКвартала(Объект.Дата);
	КонецПериода = КонецМесяца(НачалоМесяца(Объект.Дата) - 1);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗакрытиеМесяца.РасчетЕдиногоНалога КАК РасчетЕдиногоНалога
		|ИЗ
		|	Документ.ЗакрытиеМесяца КАК ЗакрытиеМесяца
		|ГДЕ
		|	ЗакрытиеМесяца.Проведен
		|	И ЗакрытиеМесяца.Организация = &Организация
		|	И ЗакрытиеМесяца.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|	И ЗакрытиеМесяца.РасчетЕдиногоНалога";
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	// Количество документов за текущий квартал, в которых рассчитан единый налог.
	КоличествоДокументов = Выборка.Количество();		
	
	// Если нет рассчитанных месяцев, то необходим расчет за квартал, иначе за месяц.
	Если КоличествоДокументов = 0 Тогда
		РасчетЕдиногоНалогаЗаКвартал = Истина;
	Иначе	
	    РасчетЕдиногоНалогаЗаКвартал = Ложь;
	КонецЕсли;
		
	// Если рассчитан только один месяц из двух (двух первых месяцев квартала), то это ошибка.
	// Необходимо чтобы либо оба месяца были рассчитаны, либо оба НЕ рассчитаны.
	Если КоличествоДокументов = 1 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
КонецФункции // ЕдиныйНалогРассчитанПравильно()
	
#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
     ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
     ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры
 
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
     ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
     ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
