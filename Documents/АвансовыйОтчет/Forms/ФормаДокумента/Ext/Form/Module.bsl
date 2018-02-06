﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДатаСеанса();
	КонецЕсли;
	
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
	
	ПодготовитьДляИзмененияПараметрыВыбораПолейСубконто();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаВажныеКоманды;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступностьЭлементов();

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)	
	
	ПодготовитьДляИзмененияПараметрыВыбораПолейСубконто();
	
КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПодборДокументовОплатыПоставщикам"
		И ТипЗнч(Параметр) = Тип("Структура")
		//Проверка на владельца формы
		И Источник <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000")
		И Источник = УникальныйИдентификатор Тогда
		
		АдресЗапасовВХранилище = Параметр.АдресЗапасовВХранилище;
		Если ЗначениеЗаполнено(АдресЗапасовВХранилище) Тогда			
			ПолучитьДанныеДокументовИзХранилища(АдресЗапасовВХранилище);	
		КонецЕсли;
		
		ТекстОповещения = НСтр("ru = 'Заполнение'");
		ТекстПояснения = НСтр("ru = 'Табличная часть ""Оплата"" заполнена.'");
		ПоказатьОповещениеПользователя(ТекстОповещения,, ТекстПояснения, БиблиотекаКартинок.Информация32);		
	КонецЕсли;
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
	
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	ЗаполнитьАвансыПоОстаткамНаКлиенте();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	БухгалтерскийУчетВызовСервера.УчетнаяПолитикаСуществует(Объект.Организация, ДатаДокумента, Истина, Объект.Ссылка);
	
	ЗаполнитьАвансыПоОстаткамНаКлиенте();
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

&НаКлиенте
Процедура ФизлицоПриИзменении(Элемент)
	ЗаполнитьАвансыПоОстаткамНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ПоВедомостиПриИзменении(Элемент)
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДвижениеДенежныхСредств

&НаКлиенте
Процедура ДвижениеДенежныхСредствПриАктивизацииСтроки(Элемент)
	
	ИмяТабличнойЧасти = "ДвижениеДенежныхСредств";
	БухгалтерскийУчетКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтотОбъект, "ТаблицаДокументов");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОплатаПоставщикам

&НаКлиенте
Процедура ОплатаПоставщикамКонтрагентПриИзменении(Элемент)	
	СтрокаТабличнойЧасти = Элементы.ОплатаПоставщикам.ТекущиеДанные;
	
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(СтрокаТабличнойЧасти.Контрагент, Объект.Организация);
	СтрокаТабличнойЧасти.ДоговорКонтрагента = СтруктураДанные.ДоговорКонтрагента;
	
	ОбработатьИзменениеДоговора(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ОплатаПоставщикамДоговорКонтрагентаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ОплатаПоставщикам.ТекущиеДанные;
	ОбработатьИзменениеДоговора(СтрокаТабличнойЧасти);	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрочее

&НаКлиенте
Процедура ПрочееСчетУчетаПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.Прочее.ТекущиеДанные;
	
	// не удалось получить- возвращаемся
	Если СтрокаТабличнойЧасти = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
								 "СубконтоДт1", "СубконтоДт2", "СубконтоДт3");

	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "Дт", "СчетУчета", "Прочее", СтрокаТабличнойЧасти, ПоляОбъекта);

КонецПроцедуры

&НаКлиенте
Процедура ПрочееСубконтоДт1ПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Прочее.ТекущиеДанные;
	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "Дт", "СчетУчета", "Прочее", СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочееСубконтоДт2ПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Прочее.ТекущиеДанные;
	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "Дт", "СчетУчета", "Прочее", СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочееСубконтоДт3ПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Прочее.ТекущиеДанные;
	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "Дт", "СчетУчета", "Прочее", СтрокаТабличнойЧасти);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыплатаЗаработнойПлаты

&НаКлиенте
Процедура ВыплатаЗаработнойПлатыВедомостьПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ВыплатаЗаработнойПлаты.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(СтрокаТабличнойЧасти.Ведомость) Тогда
		СтрокаТабличнойЧасти.Сумма = ПолучитьСуммуВедомости(СтрокаТабличнойЧасти.Ведомость);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВладельцыПатентов

&НаКлиенте
Процедура ВладельцыПатентовПриАктивизацииСтроки(Элемент)
	
	ИмяТабличнойЧасти = "ВладельцыПатентов";
	БухгалтерскийУчетКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтотОбъект, "ТоварыУслуги");
КонецПроцедуры

&НаКлиенте
Процедура ВладельцыПатентовПередУдалением(Элемент, Отказ)
	
	ИмяТабличнойЧасти = "ВладельцыПатентов";
	БухгалтерскийУчетКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтотОбъект, "ТоварыУслуги");
КонецПроцедуры

&НаКлиенте
Процедура ВладельцыПатентовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ИмяТабличнойЧасти = "ВладельцыПатентов";
	БухгалтерскийУчетКлиент.ДобавитьКлючСвязиВСтрокуТабличнойЧасти(ЭтотОбъект);
	БухгалтерскийУчетКлиент.УстановитьОтборНаПодчиненнуюТабличнуюЧасть(ЭтотОбъект, "ТоварыУслуги");
КонецПроцедуры

&НаКлиенте
Процедура ВладельцыПатентовКонтрагентПриИзменении(Элемент)	
	СтрокаТабличнойЧасти = Элементы.ВладельцыПатентов.ТекущиеДанные;
	СтруктураДанных = ПолучитьДанныеПатентаНаСервере(СтрокаТабличнойЧасти.Контрагент, ДатаДокумента);
	
	Если СтруктураДанных <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтруктураДанных);
	КонецЕсли;
	
	ИмяТабличнойЧасти = "ВладельцыПатентов";
	БухгалтерскийУчетКлиент.УдалитьСтрокиПодчиненнойТабличнойЧасти(ЭтотОбъект, "ТоварыУслуги");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТоварыУслуги

&НаКлиенте
Процедура ТоварыУслугиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	ИмяТабличнойЧасти = "ВладельцыПатентов";
	Отказ = БухгалтерскийУчетКлиент.ПередНачаломДобавленияВПодчиненнуюТабличнуюЧасть(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		ИмяТабличнойЧасти = "ТоварыУслуги";
		БухгалтерскийУчетКлиент.ДобавитьКлючСвязиВСтрокуПодчиненнойТабличнойЧасти(ЭтотОбъект, Элемент.Имя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	СтрокаТабличнойЧасти = Элементы.ТоварыУслуги.ТекущиеДанные;
	Если СтрокаТабличнойЧасти.ВидСубконтоДт1 = "Номенклатура" И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СубконтоДт1) Тогда
		СтрокаТабличнойЧасти.СубконтоДт1 = СтрокаТабличнойЧасти.Номенклатура;
	ИначеЕсли СтрокаТабличнойЧасти.ВидСубконтоДт2 = "Номенклатура" И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СубконтоДт2) Тогда
		СтрокаТабличнойЧасти.СубконтоДт2 = СтрокаТабличнойЧасти.Номенклатура;
	ИначеЕсли СтрокаТабличнойЧасти.ВидСубконтоДт3 = "Номенклатура" И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СубконтоДт3) Тогда
		СтрокаТабличнойЧасти.СубконтоДт3 = СтрокаТабличнойЧасти.Номенклатура;
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти.ВидСубконтоДт1 = "Склады" И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СубконтоДт1) Тогда
		СтрокаТабличнойЧасти.СубконтоДт1 = ПолучитьОсновнойСклад();
	ИначеЕсли СтрокаТабличнойЧасти.ВидСубконтоДт2 = "Склады" И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СубконтоДт2) Тогда
		СтрокаТабличнойЧасти.СубконтоДт2 = ПолучитьОсновнойСклад();
	ИначеЕсли СтрокаТабличнойЧасти.ВидСубконтоДт3 = "Склады" И НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.СубконтоДт3) Тогда
		СтрокаТабличнойЧасти.СубконтоДт3 = ПолучитьОсновнойСклад();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ТоварыУслуги.ТекущиеДанные;
	Если СтрокаТабличнойЧасти.ВидСубконтоДт1 = "Номенклатура" Тогда
		СтрокаТабличнойЧасти.СубконтоДт1 = СтрокаТабличнойЧасти.Номенклатура;
	ИначеЕсли СтрокаТабличнойЧасти.ВидСубконтоДт2 = "Номенклатура" Тогда
		СтрокаТабличнойЧасти.СубконтоДт2 = СтрокаТабличнойЧасти.Номенклатура;
	ИначеЕсли СтрокаТабличнойЧасти.ВидСубконтоДт3 = "Номенклатура" Тогда
		СтрокаТабличнойЧасти.СубконтоДт3 = СтрокаТабличнойЧасти.Номенклатура;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиСчетУчетаПриИзменении(Элемент)

	СтрокаТабличнойЧасти = Элементы.ТоварыУслуги.ТекущиеДанные;
	
	// не удалось получить- возвращаемся
	Если СтрокаТабличнойЧасти = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
								 "СубконтоДт1", "СубконтоДт2", "СубконтоДт3");

	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "Дт", "СчетУчета", "ТоварыУслуги", СтрокаТабличнойЧасти, ПоляОбъекта);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиСубконтоДт1ПриИзменении(Элемент)
		
	СтрокаТабличнойЧасти = Элементы.ТоварыУслуги.ТекущиеДанные;
	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "Дт", "СчетУчета", "ТоварыУслуги", СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиСубконтоДт2ПриИзменении(Элемент)
		
	СтрокаТабличнойЧасти = Элементы.ТоварыУслуги.ТекущиеДанные;
	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "Дт", "СчетУчета", "ТоварыУслуги", СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиСубконтоДт3ПриИзменении(Элемент)
		
	СтрокаТабличнойЧасти = Элементы.ТоварыУслуги.ТекущиеДанные;
	БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "Дт", "СчетУчета", "ТоварыУслуги", СтрокаТабличнойЧасти);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ТоварыУслуги.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);		
	//РассчитатьСуммыОбщие();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ТоварыУслуги.ТекущиеДанные;
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьСуммуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);		
	//РассчитатьСуммыОбщие();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыУслугиСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.ТоварыУслуги.ТекущиеДанные;	
	ОбработкаТабличныхЧастейКлиентСервер.РассчитатьЦенуСтрокиТабличнойЧасти(СтрокаТабличнойЧасти);		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОбменВалют

&НаКлиенте
Процедура ОбменВалютСуммаДоПриИзменении(Элемент)
	СтрокаТабличнойЧасти 			= Элементы.ОбменВалют.ТекущиеДанные;	
	СтрокаТабличнойЧасти.КурсОтчета = ПересчитатьКурсОбмена(СтрокаТабличнойЧасти.СуммаДо, СтрокаТабличнойЧасти.СуммаПосле);
КонецПроцедуры

&НаКлиенте
Процедура ОбменВалютСуммаяПослеПриИзменении(Элемент)
	СтрокаТабличнойЧасти 			= Элементы.ОбменВалют.ТекущиеДанные;	
	СтрокаТабличнойЧасти.КурсОтчета = ПересчитатьКурсОбмена(СтрокаТабличнойЧасти.СуммаДо, СтрокаТабличнойЧасти.СуммаПосле);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьАвансыПоОстаткам(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ФизЛицо) Тогда
		Отказ = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Не заполнено поле ""Сотрудник""! Заполнение закладки ""Авансы"" отменено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ФизЛицо",,Отказ);
		
		Если Отказ Тогда
			Возврат;	
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ДвижениеДенежныхСредств.Количество() > 0 ИЛИ  Объект.ТаблицаДокументов.Количество() > 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтветНаВопросЗаполнитьТабличнуюЧастьДвижениеДенежныхСредств", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Табличные части закладки ""Авансы"" будут перезаполнены. Продолжить выполнение операции?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60);	
	Иначе
		ЗаполнитьАвансыПоОстаткамНаКлиенте();
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьДокументыПоступления(Команда)
	ПараметрыПодбора = Новый Структура;
	
	ПараметрыПодбора.Вставить("Дата", 			 		 Объект.Дата);
	ПараметрыПодбора.Вставить("Организация", 			 Объект.Организация);
	ПараметрыПодбора.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	Если Объект.ОплатаПоставщикам.Количество() > 0 Тогда
		ДанныеТабличнойЧасти(ПараметрыПодбора);
	КонецЕсли;
	
	ОткрытьФорму("Документ.АвансовыйОтчет.Форма.ФормаПодбораДокументовОплаты", ПараметрыПодбора);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура ОтветНаВопросЗаполнитьТабличнуюЧастьДвижениеДенежныхСредств(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
        ЗаполнитьАвансыПоОстаткамНаКлиенте();
    КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура - Установить пиктограмму комментария.
//
&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	БухгалтерскийУчетКлиентСервер.УстановитьКартинкуДляКомментария(Элементы.СтраницаДополнительно, Объект.Комментарий);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСуммуВедомости(Ведомость)
	Возврат Ведомость.Зарплата.Итог("СуммаПоАвансовомуОтчету");
КонецФункции

&НаКлиенте
Процедура ОбработатьИзменениеДоговора(СтрокаТабличнойЧасти)
	
	СтруктураДанные = ПолучитьДанныеДоговораПриИзменении(Объект.Организация, Объект.Дата, 
								СтрокаТабличнойЧасти.Контрагент ,СтрокаТабличнойЧасти.ДоговорКонтрагента);	
	
	СтрокаТабличнойЧасти.Курс 		  = СтруктураДанные.Курс;
	СтрокаТабличнойЧасти.Валюта		  = СтруктураДанные.Валюта;
	СтрокаТабличнойЧасти.СчетРасчетов = СтруктураДанные.СчетРасчетов;
КонецПроцедуры

&НаСервере
Функция ПолучитьОсновнойСклад()

	Возврат БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.ТекущийПользователь(), "ОсновнойСклад");	

КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеПатентаНаСервере(Владелец, ДатаДокумента)

	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Патенты.Наименование КАК НомерПатента,
		|	Патенты.ДатаС КАК ДатаПатентаС,
		|	Патенты.ДатаПо КАК ДатаПатентаПо,
		|	Патенты.ГНС КАК ГНС,
		|	Патенты.Паспорт КАК Паспорт
		|ИЗ
		|	Справочник.Патенты КАК Патенты
		|ГДЕ
		|	Патенты.Владелец = &Владелец
		|	И Патенты.ДатаС <= &Дата
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаПатентаС УБЫВ";
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("Дата", ДатаДокумента);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтруктураДанных = Новый Структура();
		СтруктураДанных.Вставить("НомерПатента", 	Выборка.НомерПатента);
		СтруктураДанных.Вставить("ДатаПатентаС",	Выборка.ДатаПатентаС);
		СтруктураДанных.Вставить("ДатаПатентаПо", 	Выборка.ДатаПатентаПо);
		СтруктураДанных.Вставить("ГНС", 			Выборка.ГНС);
		СтруктураДанных.Вставить("Паспорт", 		Выборка.Паспорт);
		
		Возврат СтруктураДанных;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ПолучитьДанныеДокументовИзХранилища(АдресЗапасовВХранилище)
	
	ТаблицаДляЗагрузки = ПолучитьИзВременногоХранилища(АдресЗапасовВХранилище);
	
	КешДанных = Новый Соответствие();
	
	Для каждого СтрокаЗагрузки Из ТаблицаДляЗагрузки Цикл
		
		СтрокаТабличнойЧасти = Объект.ОплатаПоставщикам.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаЗагрузки);
		
		СтруктураДанные = КешДанных.Получить(СтрокаТабличнойЧасти.ДоговорКонтрагента);
	
		Если СтруктураДанные = Неопределено Тогда	
			СтруктураДанные = ПолучитьДанныеДоговораПриИзменении(Объект.Организация, Объект.Дата, 
										СтрокаТабличнойЧасти.Контрагент ,СтрокаТабличнойЧасти.ДоговорКонтрагента);
			КешДанных.Вставить(СтрокаТабличнойЧасти.ДоговорКонтрагента, СтруктураДанные); 
		КонецЕсли;
		
		СтрокаТабличнойЧасти.Курс 		  = СтруктураДанные.Курс;
		СтрокаТабличнойЧасти.Валюта		  = СтруктураДанные.Валюта;
		СтрокаТабличнойЧасти.СчетРасчетов = СтруктураДанные.СчетРасчетов;
	КонецЦикла;	
КонецПроцедуры // ПолучитьЗапасыИзХранилища()

&НаСервере
Процедура ДанныеТабличнойЧасти(ПараметрыПодбора)

	ТЗДокументовОплаты  = Объект.ОплатаПоставщикам.Выгрузить(,"ВидДокВходящий");
		
	АдресВХранилище = ПоместитьВоВременноеХранилище(ТЗДокументовОплаты);
	ПараметрыПодбора.Вставить("АдресВХранилище", АдресВХранилище); 
	
КонецПроцедуры

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
		
	Если Объект.ПоВедомости Тогда
		Элементы.ВыплатаЗаработнойПлатыФизЛицо.Видимость 	= Ложь;	
		Элементы.ВыплатаЗаработнойПлатыВедомость.Видимость 	= Истина;
		Элементы.ВыплатаЗаработнойПлатыСумма.ТолькоПросмотр = Истина;
	Иначе
		Элементы.ВыплатаЗаработнойПлатыФизЛицо.Видимость 	= Истина;
		Элементы.ВыплатаЗаработнойПлатыВедомость.Видимость 	= Ложь;
		Элементы.ВыплатаЗаработнойПлатыСумма.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()  

// Получает набор данных с сервера для процедуры КонтрагентПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеКонтрагентПриИзменении(Контрагент, Организация)
	
	ДоговорПоУмолчанию = ПолучитьДоговорПоУмолчанию(Объект.Ссылка, Контрагент, Организация);
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"ДоговорКонтрагента",
		ДоговорПоУмолчанию);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()

// Получает договор по умолчанию
//
&НаСервереБезКонтекста
Функция ПолучитьДоговорПоУмолчанию(Документ, Контрагент, Организация)
	
	МенеджерСправочника = Справочники.ДоговорыКонтрагентов;
	
	СписокВидовДоговоров = МенеджерСправочника.ПолучитьСписокВидовДоговораДляДокумента(Документ);
	ДоговорПоУмолчанию = МенеджерСправочника.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
	
	Возврат ДоговорПоУмолчанию;
	
КонецФункции

// Получает набор данных с сервера для процедуры ДатаПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеДатаПриИзменении(ДатаПередИзменением)
	РазностьДат = БухгалтерскийУчетСервер.ПроверитьНомерДокумента(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("РазностьДат",	РазностьДат);
	
	Возврат СтруктураДанные;
КонецФункции // ПолучитьДанныеДатаПриИзменении()

&НаСервереБезКонтекста
Функция ПолучитьДанныеДоговораПриИзменении(Организация, Дата, Контрагент, Договор)
	СтруктураВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Договор.ВалютаРасчетов, Дата);	
	СтруктураСчета	= БухгалтерскийУчетСервер.ПолучитьСчетаРасчетовСКонтрагентом(Организация, Контрагент, Договор);
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Валюта", 		 СтруктураВалюты.Валюта);
	СтруктураДанные.Вставить("Курс", 		 СтруктураВалюты.Курс);
	СтруктураДанные.Вставить("СчетРасчетов", СтруктураСчета.СчетРасчетовПоставщика);
		
	Возврат СтруктураДанные;
КонецФункции

&НаСервереБезКонтекста
Функция ПересчитатьКурсОбмена(Сумма, СуммаОтчета)
	Если Сумма <> 0 И СуммаОтчета <> 0 Тогда
		Если СуммаОтчета > Сумма Тогда
			Возврат Окр(СуммаОтчета / Сумма, 4);
		Иначе
			Возврат Окр(Сумма / СуммаОтчета, 4);
		КонецЕсли;
	Иначе
		Возврат 0;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ПодготовитьДляИзмененияПараметрыВыбораПолейСубконто()

	ПоляОбъекта = Новый Структура("Субконто1, Субконто2, Субконто3",
									"СубконтоДт1", "СубконтоДт2", "СубконтоДт3");
										
	Для Каждого СтрокаТабличнойЧасти Из Объект.Прочее Цикл							 
		БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "Дт", "СчетУчета", "Прочее", СтрокаТабличнойЧасти, ПоляОбъекта);
	КонецЦикла;
	
	Для Каждого СтрокаТабличнойЧасти Из Объект.ТоварыУслуги Цикл							 
		БухгалтерскийУчетКлиентСервер.НастроитьСвязьСчетаИСубконтоВТЧ(ЭтаФорма, "Дт", "СчетУчета", "ТоварыУслуги", СтрокаТабличнойЧасти, ПоляОбъекта);
	КонецЦикла;	

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьАвансыПоОстаткамНаКлиенте()
	Объект.ДвижениеДенежныхСредств.Очистить();
	Объект.ТаблицаДокументов.Очистить();	
	
	ЗаполнитьАвансыПоОстаткамНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАвансыПоОстаткамНаСервере()
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ЗаполнитьАвансы(ДатаДокумента);
	ЗначениеВРеквизитФормы(Документ, "Объект");
	
	Если Объект.ДвижениеДенежныхСредств.Количество() > 0 Тогда
		Объект.СуммаДокумента  = Объект.ДвижениеДенежныхСредств[0].ОстатокНаКонец;
		Объект.ВалютаДокумента = Объект.ДвижениеДенежныхСредств[0].Валюта;
	КонецЕсли;
КонецПроцедуры

//&НаКлиенте
//Процедура РассчитатьСуммыОбщие()
//	
//	СуммаОплатаПоставщикам 	= Объект.ОплатаПоставщикам.Итог("Сумма");
//	СуммаПрочее 			= Объект.Прочее.Итог("Сумма");
//	СуммаВыплатаЗП 			= Объект.Прочее.Итог("Сумма");
//	СуммаТоварыУслуги		= Объект.ТоварыУслуги.Итог("Сумма");
//	
//	СуммаДокумента         	= 
//		СуммаОплатаПоставщикам 	 			
//		+ СуммаПрочее 			
//		+ СуммаВыплатаЗП        
//		+ СуммаТоварыУслуги;	
//		
//КонецПроцедуры

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
