﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ЗаполнитьПризнакиПоГруппамИмущества();
	УстановитьОтборДляСписковГруппИмущества();
	УстановитьПараметрыВыбора();	

	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
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

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборОСПроизведен" 
		И ЗначениеЗаполнено(Параметр) 
		// Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр;
		ПолучитьОСИзХранилища(АдресЗапасовВХранилище, "ОС");
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	ЗаполнитьПризнакиПоГруппамИмущества();
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
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервераПовтИсп.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
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

// Процедура - обработчик события ПриИзменении поля ввода Вид операции.
//
&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.ОбъектыСтроительства") Тогда
		Объект.СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.НезавершенноеСтроительство_");
	ИначеЕсли Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.ПоРезультатамИнвентаризации") Тогда
		Объект.СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ПрочиеДоходыОтНеоперационнойДеятельности");
	Иначе
		Объект.СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ПустаяСсылка");
	КонецЕсли; 
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры  

&НаКлиенте
Процедура ОСПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)	
	Если НоваяСтрока 
		И Не Копирование Тогда
		СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;	
		СтрокаТабличнойЧасти.СпособНачисленияАмортизации = ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииОС.Линейный");
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОСПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ОСПослеУдаления(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОС

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("ОсновноеСредство", СтрокаТабличнойЧасти.ОсновноеСредство);

	СтруктураДанные = ПолучитьДанныеОСПриИзменении(СтруктураДанные);
	
	СтрокаТабличнойЧасти.СчетУчета = СтруктураДанные.СчетУчета;
	СтрокаТабличнойЧасти.ИнвентарныйНомер = СтруктураДанные.ИнвентарныйНомер;
КонецПроцедуры

&НаКлиенте
Процедура ОСГруппаИмуществаПриИзменении(Элемент)
	// Для отбора в списках Недвижимость и Транспорт.
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ1")
		Или СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ2")
		Или СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ3") Тогда 
		
		СтрокаТабличнойЧасти.ГруппаИмуществаНедвижимость = Истина;
		СтрокаТабличнойЧасти.ГруппаИмуществаТранспорт = Ложь;
		
		СтрокаТабличнойЧасти.КатегорияИмущества = "";
		СтрокаТабличнойЧасти.КодПользователяИмущества = "";
		
		СтрокаТабличнойЧасти.ДатаНачисленияНалогаНаИмущество = НачалоМесяца(ДатаДокумента);
		
	ИначеЕсли СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ4")	Тогда 
		СтрокаТабличнойЧасти.ГруппаИмуществаНедвижимость = Ложь;
		СтрокаТабличнойЧасти.ГруппаИмуществаТранспорт = Истина;
		
		СтрокаТабличнойЧасти.КатегорияИмущества = ПредопределенноеЗначение("Справочник.КатегорияОбъектаИмущества.О");
		СтрокаТабличнойЧасти.КодПользователяИмущества = ПредопределенноеЗначение("Справочник.КодыПользователейИмущества.Собственник");		
		
		СтрокаТабличнойЧасти.ДатаНачисленияНалогаНаИмущество = НачалоГода(ДатаДокумента);
		
	Иначе 
		СтрокаТабличнойЧасти.ГруппаИмуществаНедвижимость = Ложь;
		СтрокаТабличнойЧасти.ГруппаИмуществаТранспорт = Ложь;
		
		СтрокаТабличнойЧасти.КатегорияИмущества = "";
		СтрокаТабличнойЧасти.КодПользователяИмущества = "";
		
		СтрокаТабличнойЧасти.ДатаНачисленияНалогаНаИмущество = Дата(1, 1, 1);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОСПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.ОбъектыСтроительства") И Объект.ОС.Количество() >= 1 Тогда
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Для одного объекта строительства должна быть одна строка записи'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОС", , Отказ);	
		
	КонецЕсли;		

КонецПроцедуры

&НаКлиенте
Процедура ОСПервоначальнаяСтоимостьПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.СтоимостьДляРасчетаАмортизации = СтрокаТабличнойЧасти.ПервоначальнаяСтоимость - СтрокаТабличнойЧасти.ЛиквидационнаяСтоимость;

КонецПроцедуры

&НаКлиенте
Процедура ОСЛиквидационнаяСтоимостьПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.СтоимостьДляРасчетаАмортизации = СтрокаТабличнойЧасти.ПервоначальнаяСтоимость - СтрокаТабличнойЧасти.ЛиквидационнаяСтоимость;

КонецПроцедуры

&НаКлиенте
Процедура ОСДатаНачисленияНалогаНаИмуществоПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.ДатаНачисленияНалогаНаИмущество) Тогда
		Если СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ1")
			Или СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ2")
			Или СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ3") Тогда 
			
			СтрокаТабличнойЧасти.ДатаНачисленияНалогаНаИмущество = НачалоМесяца(СтрокаТабличнойЧасти.ДатаНачисленияНалогаНаИмущество);
		ИначеЕсли СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ4")	Тогда 
			СтрокаТабличнойЧасти.ДатаНачисленияНалогаНаИмущество = НачалоГода(СтрокаТабличнойЧасти.ДатаНачисленияНалогаНаИмущество);
		Иначе 
			СтрокаТабличнойЧасти.ДатаНачисленияНалогаНаИмущество = Дата(1, 1, 1);
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик события Действие команды Подбор
//
&НаКлиенте
Процедура ПодборОС(Команда)
	УправлениеВнеоборотнымиАктивамиКлиент.ОткрытьПодбор(ЭтаФорма, "ОС");  
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДляСписка(Команда)
	Отказ = Ложь;
	
	Если Объект.ОС.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена табличная часть ""ОС""! Операция отменена.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОС",,Отказ);		
	КонецЕсли;

	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	Если Объект.ОС.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьДляСписка", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные табличной части документа будут перезаполнены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	Иначе
		ДополнитьСтрокиНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНаименованию(Команда)
	// получаем текущую строку
	СтрокаТабличнойЧасти = Элементы.ОС.ТекущиеДанные;
	
	Отказ = Ложь;
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Не выбрана строка для заполнения! Операция отменена.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОС",,Отказ);		
	ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ОсновноеСредство) Тогда
		ТекстСообщения = НСтр("ru = 'В выбранной строке не заполнено основное средство! Операция отменена.'");
		ПолеСообщения = СтрШаблон("Объект.ОС[%1].ОсновноеСредство", СтрокаТабличнойЧасти.НомерСтроки-1);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,ПолеСообщения,,Отказ);		
	КонецЕсли;
	
	Если Отказ Тогда 
		Возврат
	КонецЕсли;		
	
	ДополнительныеПараметры = Новый Структура("ОсновноеСредство", СтрокаТабличнойЧасти.ОсновноеСредство);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьПоНаименованию", ЭтотОбъект, ДополнительныеПараметры);
	ТекстВопроса = НСтр("ru = 'Табличная часть документа будет дозаполнена! Продолжить выполнение операции?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьОборудование(Команда)
	
	Если Объект.ОС.Количество() > 0 Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьДляСписка", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные табличной части документа будут перезаполнены! Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);
	Иначе
		ДополнитьСтрокиНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьДляСписка(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда		
		ДополнитьСтрокиНаСервере();		
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьПоНаименованию(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоНаименованиюНаСервере(ДополнительныеПараметры.ОсновноеСредство);
	КонецЕсли; 
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.СчетУчета.Видимость               			= Ложь;
	Элементы.Номенклатура.Видимость   					= Ложь;
	Элементы.ОбъектСтроительства.Видимость  			= Ложь;
	Элементы.Склад.Видимость  							= Ложь;
	Элементы.ОСПересчитатьОборудование.Видимость  		= Ложь;
	
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуОсновныхСредств.Оборудование Тогда
		Элементы.СчетУчета.Видимость = Истина;
		Элементы.Номенклатура.Видимость = Истина;
		Элементы.Склад.Видимость = Истина;
		
		Элементы.ОСЗаполнитьДляСписка.Видимость = Ложь;
		Элементы.ОСЗаполнитьПоНаименованию.Видимость = Ложь;
		Элементы.ОСПересчитатьОборудование.Видимость = Истина;
		
	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуОсновныхСредств.ОбъектыСтроительства Тогда
		Элементы.СчетУчета.Видимость = Истина;
		Элементы.ОбъектСтроительства.Видимость = Истина;
		
		Элементы.ОСЗаполнитьДляСписка.Видимость = Истина;
		Элементы.ОСЗаполнитьПоНаименованию.Видимость = Истина;

	ИначеЕсли Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуОсновныхСредств.ПоРезультатамИнвентаризации Тогда
		Элементы.СчетУчета.Видимость = Истина;
		
		Элементы.ОСЗаполнитьДляСписка.Видимость = Истина;
		Элементы.ОСЗаполнитьПоНаименованию.Видимость = Истина;
	Иначе
		
		Элементы.ОСЗаполнитьДляСписка.Видимость = Истина;
		Элементы.ОСЗаполнитьПоНаименованию.Видимость = Истина;
	КонецЕсли;
		
	// Видимость страниц имущества.
	НайденныеСтрокиГИ1 = Объект.ОС.НайтиСтроки(Новый Структура("ГруппаИмущества", Справочники.ГруппыИмущества.ГИ1));
	НайденныеСтрокиГИ2 = Объект.ОС.НайтиСтроки(Новый Структура("ГруппаИмущества", Справочники.ГруппыИмущества.ГИ2));
	НайденныеСтрокиГИ3 = Объект.ОС.НайтиСтроки(Новый Структура("ГруппаИмущества", Справочники.ГруппыИмущества.ГИ3));
	НайденныеСтрокиГИ4 = Объект.ОС.НайтиСтроки(Новый Структура("ГруппаИмущества", Справочники.ГруппыИмущества.ГИ4));
	
	НедвижимостьКоличество = НайденныеСтрокиГИ1.Количество() + НайденныеСтрокиГИ2.Количество() + НайденныеСтрокиГИ3.Количество();
	ТранспортКоличество = НайденныеСтрокиГИ4.Количество();
	
	Элементы.СтраницаОСНедвижимость.Видимость = НедвижимостьКоличество > 0;
	Элементы.СтраницаОСТранспорт.Видимость = ТранспортКоличество > 0;
	
	// Обновление заголовка подчиненных списков.
	Элементы.СтраницаОСНедвижимость.Заголовок = СтрШаблон(НСтр("ru = 'Недвижимость (%1)'"), НедвижимостьКоличество);
	Элементы.СтраницаОСТранспорт.Заголовок = СтрШаблон(НСтр("ru = 'Транспорт (%1)'"), ТранспортКоличество);
	
	// Видимость страницы ОСГруппа10 (Параметр выработки, Объем продукции).
	НайденнаяСтрокаСоСпособомПроизводственный = Объект.ОС.НайтиСтроки(Новый Структура("СпособНачисленияАмортизации", Перечисления.СпособыНачисленияАмортизацииОС.Производственный));
	КоличествоПроизводственный = НайденнаяСтрокаСоСпособомПроизводственный.Количество();
	Элементы.ОСГруппаПроизводственныйМетод.Видимость = КоличествоПроизводственный > 0;

	// Видимость колонки Коэффициент ускорения
	НайденнаяСтрокаСоСпособомУмОстатка = Объект.ОС.НайтиСтроки(Новый Структура("СпособНачисленияАмортизации", Перечисления.СпособыНачисленияАмортизацииОС.УменьшаемогоОстатка));
	КоличествоУмОстатка = НайденнаяСтрокаСоСпособомУмОстатка.Количество();
	Элементы.ОСКоэффициентУскорения.Видимость = КоличествоУмОстатка > 0;

КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьПризнакиПоГруппамИмущества()
	Для Каждого СтрокаТабличнойЧасти Из Объект.ОС Цикл 
		Если СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ1")
			Или СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ2")
			Или СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ3") Тогда 
			
			СтрокаТабличнойЧасти.ГруппаИмуществаНедвижимость = Истина;
			СтрокаТабличнойЧасти.ГруппаИмуществаТранспорт = Ложь;
		ИначеЕсли СтрокаТабличнойЧасти.ГруппаИмущества = ПредопределенноеЗначение("Справочник.ГруппыИмущества.ГИ4")	Тогда 
			СтрокаТабличнойЧасти.ГруппаИмуществаНедвижимость = Ложь;
			СтрокаТабличнойЧасти.ГруппаИмуществаТранспорт = Истина;
		Иначе 
			СтрокаТабличнойЧасти.ГруппаИмуществаНедвижимость = Ложь;
			СтрокаТабличнойЧасти.ГруппаИмуществаТранспорт = Ложь;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры // ЗаполнитьПризнакиПоГруппамИмущества()

// Процедура - Установить отбор для списков групп имущества
//
&НаСервере
Процедура УстановитьОтборДляСписковГруппИмущества()
	// Отбор по станицам
	Элементы.Недвижимость.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ГруппаИмуществаНедвижимость", Истина));
	Элементы.Транспорт.ОтборСтрок = Новый ФиксированнаяСтруктура(Новый Структура("ГруппаИмуществаТранспорт", Истина));
КонецПроцедуры // УстановитьОтборДляСписковГруппИмущества()

// Процедура - Установить параметры выбора
//
&НаСервере
Процедура УстановитьПараметрыВыбора()
	// Основные средства.
	МассивСчетов = БухгалтерскийУчетВызовСервераПовтИсп.СчетаУчетаОсновныхСредствИНематериальныхАктивов();
	ФиксированныйМассивСчетов = Новый ФиксированныйМассив(МассивСчетов);
	НовыйПараметр = Новый ПараметрВыбора("Отбор.Ссылка", ФиксированныйМассивСчетов);
	НовыйМассив = Новый Массив();
	НовыйМассив.Добавить(НовыйПараметр);
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	Элементы.ОССчетУчета.ПараметрыВыбора = НовыеПараметры;
КонецПроцедуры // УстановитьПараметрыВыбора()

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

// Процедура получает список ОС из временного хранилища
//
&НаСервере
Процедура ПолучитьОСИзХранилища(АдресЗапасовВХранилище, ИмяТабличнойЧасти)
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	МассивОС = Новый Массив;
	Отказ = Ложь;
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.ОбъектыСтроительства") И ТаблицаДляЗагрузки.Количество() > 1 Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Для одного объекта строительства должна быть одна строка записи.'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОС", , Отказ);
		Возврат;
	Иначе
		Для Каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
			НайденныеСтроки = Объект.ОС.НайтиСтроки(Новый Структура("ОсновноеСредство", СтрокаЗагрузки.ОсновноеСредство));
			
			Если НайденныеСтроки.Количество() > 0 Тогда 
				Продолжить;
			КонецЕсли;	
			
			СтрокаТабличнойЧасти = Объект.ОС.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
			
			// Заполнение основных параметров.
			// Имееь смысл при виде операции "Оборудование".
			СтруктураДанные = Новый Структура;
			СтруктураДанные.Вставить("ОсновноеСредство", СтрокаТабличнойЧасти.ОсновноеСредство);
			СтруктураДанные = ПолучитьДанныеОСПриИзменении(СтруктураДанные);

			СтрокаТабличнойЧасти.ПервоначальнаяСтоимость = СтрокаЗагрузки.Стоимость;
			СтрокаТабличнойЧасти.СтоимостьДляРасчетаАмортизации = СтрокаТабличнойЧасти.ПервоначальнаяСтоимость - СтрокаТабличнойЧасти.ЛиквидационнаяСтоимость;
			СтрокаТабличнойЧасти.СчетУчета = СтруктураДанные.СчетУчета;
			СтрокаТабличнойЧасти.ИнвентарныйНомер = СтруктураДанные.ИнвентарныйНомер;
			СтрокаТабличнойЧасти.СпособНачисленияАмортизации = Перечисления.СпособыНачисленияАмортизацииОС.Линейный;
			
			МассивОС.Добавить(СтрокаТабличнойЧасти.ОсновноеСредство);
		КонецЦикла;
		
		ДополнитьСтрокиНаСервере(МассивОС);
	КонецЕсли;
		
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

// Процедура заполняет строки
//
// Параметры:
//  МассивОС  - Массив - массив ОС, по которым нужно заполнить строки, если не указано- заполняются все строки
//
&НаСервере
Процедура ДополнитьСтрокиНаСервере(МассивОС = Неопределено)
	Если Объект.ВидОперации = Перечисления.ВидыОперацийПринятияКУчетуОсновныхСредств.Оборудование Тогда
		ДополнитьСтрокиНаСервереОборудование();	
	Иначе
		ДополнитьСтрокиНаСервереНеОборудование(МассивОС)	
	КонецЕсли;
	
КонецПроцедуры // ДополнитьСтрокиНаСервере()

// Процедура заполняет строки для вида операции Оборудование
//
&НаСервере
Процедура ДополнитьСтрокиНаСервереОборудование()
	Отказ = Ложь;
	// Подготовка данных	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ВременнаяТаблицаОС.НомерСтроки КАК НомерСтроки,
		|	ВременнаяТаблицаОС.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
		|ПОМЕСТИТЬ ВременнаяТаблицаОС
		|ИЗ
		|	&ТаблицаОС КАК ВременнаяТаблицаОС
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	&Ссылка КАК Регистратор,
		|	&Дата КАК Период,
		|	&Организация КАК Организация,
		|	&Содержание КАК Содержание,
		|	&Склад КАК Склад
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	""Товары"" КАК ИмяСписка,
		|	&СинонимСписка КАК СинонимСписка,
		|	&Дата КАК Период,
		|	ВременнаяТаблицаОС.НомерСтроки КАК НомерСтроки,
		|	&СчетУчета КАК СчетУчета,
		|	&Номенклатура КАК Номенклатура,
		|	&Склад КАК Склад,
		|	НЕОПРЕДЕЛЕНО КАК ДокументОприходования,
		|	0 КАК Себестоимость,
		|	1 КАК Количество,
		|	ВременнаяТаблицаОС.СчетУчета КАК КорСчетСписания,
		|	ВременнаяТаблицаОС.ОсновноеСредство КАК КорСубконто1,
		|	НЕОПРЕДЕЛЕНО КАК КорСубконто2,
		|	НЕОПРЕДЕЛЕНО КАК КорСубконто3
		|ИЗ
		|	ВременнаяТаблицаОС КАК ВременнаяТаблицаОС
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	
	Запрос.УстановитьПараметр("Содержание", НСтр("ru = 'Поступление основного средства'")); 
	Запрос.УстановитьПараметр("СинонимСписка", НСтр("ru = 'Товары'"));
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);	
	Запрос.УстановитьПараметр("Дата", Объект.Дата);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Склад", Объект.Склад);
	Запрос.УстановитьПараметр("СчетУчета", Объект.СчетУчета);
	Запрос.УстановитьПараметр("Номенклатура", Объект.Номенклатура);
	Запрос.УстановитьПараметр("ТаблицаОС", Объект.ОС.Выгрузить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты = МассивРезультатов[1].Выгрузить();
	ТаблицаТовары = МассивРезультатов[2].Выгрузить();
	
	ТаблицаСписанныеТовары = УчетТоваров.ПодготовитьТаблицуСписанныеТовары(ТаблицаТовары, ТаблицаРеквизиты, Отказ);
	
	Для каждого СтрокаТовары Из ТаблицаСписанныеТовары Цикл
		СтрокиТабличнойЧасти = Объект.ОС.НайтиСтроки(Новый Структура("ОсновноеСредство", СтрокаТовары.КорСубконто1));
		Для Каждого СтрокаТабличнойЧасти Из СтрокиТабличнойЧасти Цикл
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовары,,"СчетУчета");
			СтрокаТабличнойЧасти.ПервоначальнаяСтоимость = СтрокаТовары.СуммаСписания;
			СтрокаТабличнойЧасти.СтоимостьДляРасчетаАмортизации = СтрокаТабличнойЧасти.ПервоначальнаяСтоимость - СтрокаТабличнойЧасти.ЛиквидационнаяСтоимость;
		КонецЦикла;		
	КонецЦикла;
	
КонецПроцедуры // ДополнитьСтрокиНаСервереОборудование()

// Процедура заполняет строки для всех видов операций, кроме вида операции Оборудование
//
&НаСервере
Процедура ДополнитьСтрокиНаСервереНеОборудование(МассивОС)
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПринятияКУчетуОсновныхСредств.ОбъектыСтроительства") Тогда
		
		Для Каждого СтрокаТабличнойЧасти Из Объект.ОС Цикл
				СтрокаТабличнойЧасти.ПервоначальнаяСтоимость = ПолучитьПервоначальнуюСтоимостьОСДляОбъектаСтроительства();
				СтрокаТабличнойЧасти.СтоимостьДляРасчетаАмортизации = СтрокаТабличнойЧасти.ПервоначальнаяСтоимость 
																		- СтрокаТабличнойЧасти.ЛиквидационнаяСтоимость;
		КонецЦикла;		
	КонецЕсли;
	
	Если МассивОС = Неопределено  Тогда 
		МассивОС = Объект.ОС.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство");
	КонецЕсли;		
	
	Если МассивОС.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПараметрыУчетаОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство,
		|	ПараметрыУчетаОССрезПоследних.СчетУчета КАК СчетУчета,
		|	ЗНАЧЕНИЕ(Перечисление.СпособыНачисленияАмортизацииОС.Линейный) КАК СпособНачисленияАмортизации
		|ПОМЕСТИТЬ ВременнаяТаблицаПараметрыУчетаОС
		|ИЗ
		|	РегистрСведений.ПараметрыУчетаОС.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ОсновноеСредство В (&МассивОС)
		|				И НЕ Регистратор = &Ссылка) КАК ПараметрыУчетаОССрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОсновноеСредство,
		|	СчетУчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВременнаяТаблицаПараметрыУчетаОС.ОсновноеСредство КАК ОсновноеСредство,
		|	ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстаток, 0) КАК ПервоначальнаяСтоимость,
		//|	ЕСТЬNULL(ХозрасчетныйОстатки.СуммаОстаток, 0) КАК СтоимостьДляРасчетаАмортизации,
		|	ВременнаяТаблицаПараметрыУчетаОС.СчетУчета КАК СчетУчета,
		|	ВременнаяТаблицаПараметрыУчетаОС.СпособНачисленияАмортизации КАК СпособНачисленияАмортизации
		|ИЗ
		|	ВременнаяТаблицаПараметрыУчетаОС КАК ВременнаяТаблицаПараметрыУчетаОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Хозрасчетный.Остатки(
		|				&Период,
		|				Счет В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВременнаяТаблицаПараметрыУчетаОС.СчетУчета
		|					ИЗ
		|						ВременнаяТаблицаПараметрыУчетаОС),
		|				ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ОсновныеСредства),
		|				Организация = &Организация
		|					И Субконто1 В (&МассивОС)) КАК ХозрасчетныйОстатки
		|		ПО ВременнаяТаблицаПараметрыУчетаОС.ОсновноеСредство = ХозрасчетныйОстатки.Субконто1";
	Запрос.УстановитьПараметр("Период", ДатаДокумента);	
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("МассивОС", МассивОС);

	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокиТабличнойЧасти = Объект.ОС.НайтиСтроки(Новый Структура("ОсновноеСредство", ВыборкаДетальныеЗаписи.ОсновноеСредство));
		Для Каждого СтрокаТабличнойЧасти Из СтрокиТабличнойЧасти Цикл
			ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи);
			СтрокаТабличнойЧасти.СтоимостьДляРасчетаАмортизации = СтрокаТабличнойЧасти.ПервоначальнаяСтоимость - СтрокаТабличнойЧасти.ЛиквидационнаяСтоимость; 
		КонецЦикла;		
	КонецЦикла;
	
КонецПроцедуры // ДополнитьСтрокиНаСервереОборудование()

// Процедура - Заполнить по наименованию на сервере
//
// Параметры:
//  СтрокаТабличнойЧасти - СтрокаТабличнойЧасти - строка, по данным которой нужно выполнить заполнение
//
&НаСервере
Процедура ЗаполнитьПоНаименованиюНаСервере(ОсновноеСредство)
	НаименованиеОС = ОсновноеСредство.Наименование;
	
	МассивОС = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СостоянияОССрезПоследних.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	РегистрСведений.СостоянияОС.СрезПоследних(
		|			&Период,
		|			Организация = &Организация
		|				И ОсновноеСредство.Наименование = &НаименованиеОС
		|				И НЕ Регистратор = &Ссылка) КАК СостоянияОССрезПоследних
		|ГДЕ
		|	СостоянияОССрезПоследних.Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийОС.Поступило)";
	Запрос.УстановитьПараметр("Период", ДатаДокумента);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("НаименованиеОС", НаименованиеОС);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокиТабличнойЧасти = Объект.ОС.НайтиСтроки(Новый Структура("ОсновноеСредство", ВыборкаДетальныеЗаписи.ОсновноеСредство));
		
		Если СтрокиТабличнойЧасти.Количество() > 0 Тогда 
			Продолжить;	
		КонецЕсли;
		
		СтрокаТабличнойЧасти = Объект.ОС.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ВыборкаДетальныеЗаписи);
		
		МассивОС.Добавить(СтрокаТабличнойЧасти.ОсновноеСредство);
	КонецЦикла;

	ДополнитьСтрокиНаСервере(МассивОС);
КонецПроцедуры // ЗаполнитьПоНаименованиюНаСервере()

// Процедура - Заполнить по наименованию на сервере
//
// Параметры:
//  ПервоначальнаяСтоимость - реквизит табличной части "ОС"
//
&НаСервере
Функция ПолучитьПервоначальнуюСтоимостьОСДляОбъектаСтроительства()
	
	ПервоначальнаяСтоимость = 0;
	
	Запрос = Новый Запрос;
	Запрос.Текст =	
	
	"ВЫБРАТЬ
	|	ТиповойОстатки.Субконто1,
	|	ТиповойОстатки.СуммаОстаток КАК Сумма,
	|	ТиповойОстатки.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&Период,
	|			Счет = &СчетДт,
	|			&МассивСубконто,
	|			Субконто1 = &ОбъектыСтроительства) КАК ТиповойОстатки";
	
	МассивСубконто = Новый Массив;	
	МассивСубконто.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ОбъектыСтроительства);
	
	Запрос.УстановитьПараметр("МассивСубконто", МассивСубконто);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.УстановитьПараметр("СчетДт", Объект.СчетУчета);
	Запрос.УстановитьПараметр("ОбъектыСтроительства", Объект.ОбъектСтроительства);
	
	ТЗ = Запрос.Выполнить().Выгрузить();                    
	Если ТЗ.Количество() = 0 Тогда
		Отказ = Ложь;
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Данного объекта строительства нет.'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.ОС", , Отказ);
	Иначе
		ПервоначальнаяСтоимость = ТЗ[0].Сумма;
	КонецЕсли;
	
	Возврат ПервоначальнаяСтоимость;
КонецФункции

// Получает набор данных с сервера для процедуры ОСПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеОСПриИзменении(СтруктураДанные)
	
	СтруктураДанные.Вставить(
		"ИнвентарныйНомер",
		СтруктураДанные.ОсновноеСредство.Код);
		
	СтруктураДанные.Вставить(
		"СчетУчета",
		ПланыСчетов.Хозрасчетный.Оборудование);
		
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеОСПриИзменении()

#КонецОбласти

#Область ПроцедурыИФункцииКомиссия

// Процедура - обработчик события команды ПодборФизическихЛиц.
// Открывает форму выбора.
//
&НаКлиенте
Процедура ПодборФизическихЛиц(Команда)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	ОткрытьФорму("Справочник.ФизическиеЛица.ФормаВыбора", ПараметрыФормы, Элементы.Комиссия);

КонецПроцедуры

// Процедура - обработчик события ПередУдалением таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияПередУдалением(Элемент, Отказ)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;
	Если ТекущаяСтрокаТЧ.Председатель Тогда
		ИндексУдаляемойСтроки = Объект.Комиссия.Индекс(ТекущаяСтрокаТЧ);
		КоличествоСтрок = Объект.Комиссия.Количество() - 1;

		Если КоличествоСтрок > 0 Тогда
			Если ИндексУдаляемойСтроки <= КоличествоСтрок - 1 Тогда
				ИндексНовогоПредседателя = ИндексУдаляемойСтроки + 1;
			Иначе
				ИндексНовогоПредседателя = КоличествоСтрок - 1;
			КонецЕсли;
			Объект.Комиссия[ИндексНовогоПредседателя].Председатель = Истина;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриНачалеРедактирования таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если Копирование Тогда
		ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;
		ТекущаяСтрокаТЧ.ФизЛицо = Неопределено;
		ТекущаяСтрокаТЧ.Председатель = Ложь;
	Иначе // Создание заново
		Если Объект.Комиссия.Количество() = 1 Тогда
			Объект.Комиссия[0].Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора таблицы Комиссия.
//
&НаКлиенте
Процедура КомиссияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Строки = Объект.Комиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

	Если Строки.Количество() > 0 Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Физическое лицо ""%1"" уже подобрано!'"), ВыбранноеЗначение);
		ПоказатьПредупреждение(, ТекстСообщения, 60);
	Иначе
		НоваяСтрока = Объект.Комиссия.Добавить();
		НоваяСтрока.ФизЛицо = ВыбранноеЗначение;
		Если Объект.Комиссия.Количество() = 1 Тогда
			НоваяСтрока.Председатель = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Председатель.
//
&НаКлиенте
Процедура КомиссияПредседательПриИзменении(Элемент)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;

	Если НЕ ТекущаяСтрокаТЧ.Председатель Тогда
		// Снимать флажок нельзя
		ТекущаяСтрокаТЧ.Председатель = Истина;
		Возврат;
	КонецЕсли;

	Для каждого СтрокаТЧ Из Объект.Комиссия Цикл
		Если СтрокаТЧ.НомерСтроки <> ТекущаяСтрокаТЧ.НомерСтроки Тогда
			СтрокаТЧ.Председатель = Ложь;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ФизЛицо.
//
&НаКлиенте
Процедура КомиссияФизЛицоПриИзменении(Элемент)

	Если Объект.Комиссия.Количество() = 1 Тогда
		Объект.Комиссия[0].Председатель = Истина;
	КонецЕсли;

КонецПроцедуры

// Процедура - обработчик события ОбработкаВыбора поля ввода ФизЛицо.
//
&НаКлиенте
Процедура КомиссияФизЛицоОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	ТекущаяСтрокаТЧ = Элементы.Комиссия.ТекущиеДанные;

	Если ТекущаяСтрокаТЧ.ФизЛицо <> ВыбранноеЗначение Тогда

		СтрокиТабличнойЧасти = Объект.Комиссия.НайтиСтроки(Новый Структура("ФизЛицо", ВыбранноеЗначение));

		Если СтрокиТабличнойЧасти.Количество() > 0 Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Физическое лицо ""%1"" уже включено в состав комиссии!'"), ВыбранноеЗначение);
			ПоказатьПредупреждение(, ТекстСообщения, 60);
			СтандартнаяОбработка = Ложь;
		КонецЕсли;

	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
