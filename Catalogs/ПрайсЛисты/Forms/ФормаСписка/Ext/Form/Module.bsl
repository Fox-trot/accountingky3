﻿
#Область СобытияФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	ЗначениеНастройки = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяФормаПрайсЛиста");
	Элементы.ЭтоОсновнаяФормаПрайсЛистов.Пометка = (НЕ ЗначениеЗаполнено(ЗначениеНастройки) ИЛИ ЗначениеНастройки = Перечисления.ОсновнаяФормаПрайсЛиста.СписокПрайсЛистов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	
	Если ДанныеТекущейСтроки <> Неопределено Тогда
		
		ОткрытьФорму("Обработка.ФормированиеПрайсЛистов.Форма", Новый Структура("ПрайсЛист", ДанныеТекущейСтроки.Ссылка), ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтоОсновнаяФормаПрайсЛистов(Команда)
	
	ИзменитьНастройкуОсновнойФормыПрайсЛистов();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеМетоды

&НаСервере
Процедура ИзменитьНастройкуОсновнойФормыПрайсЛистов()
	
	Элементы.ЭтоОсновнаяФормаПрайсЛистов.Пометка = НЕ Элементы.ЭтоОсновнаяФормаПрайсЛистов.Пометка;
	ЗначениеНастройки = Перечисления.ОсновнаяФормаПрайсЛиста[?(Элементы.ЭтоОсновнаяФормаПрайсЛистов.Пометка, "СписокПрайсЛистов", "ФормированиеПрайсЛистов")];
	
	ОбщегоНазначенияБПСервер.УстановитьЗначениеПоУмолчанию("ОсновнаяФормаПрайсЛиста", ЗначениеНастройки);
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти
